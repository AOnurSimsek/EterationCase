//
//  CoreDataManager.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

import Foundation
import CoreData

enum SaveType {
    case favorite
    case cart
}

protocol CoreDataService: AnyObject {
    func saveFavoriteProduct(id: Int)
    func getFavoriteProducts() -> [Int]
    func deleteFavoriteItem(id: Int)
    func saveCartProduct(id: Int)
    func getCartProducts() -> [NSManagedObject]
    func deleteCartProduct(id: Int)
}

final class CoreDataManager: CoreDataService {
    static let shared = CoreDataManager()
        
    private lazy var persistentContainer: NSPersistentContainer = {
        let managedObjects = NSManagedObjectModel()
        
        let cartProductEntity: NSEntityDescription = NSEntityDescription()
        cartProductEntity.name = CoreDataConstanst.cartEntityName
        cartProductEntity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        
        let productId = NSAttributeDescription()
        productId.name = CoreDataConstanst.productId
        productId.attributeType = .integer32AttributeType
        productId.isOptional = false
        
        let quantity = NSAttributeDescription()
        quantity.name = CoreDataConstanst.productQuantity
        quantity.attributeType = .integer32AttributeType
        quantity.isOptional = false
        
        cartProductEntity.properties = [productId, quantity]
        
        let favoriteProductId = NSAttributeDescription()
        favoriteProductId.name = CoreDataConstanst.productId
        favoriteProductId.attributeType = .integer32AttributeType
        favoriteProductId.isOptional = false
        
        let favoriteProductEntity = NSEntityDescription()
        favoriteProductEntity.name = CoreDataConstanst.favoriteEntityName
        favoriteProductEntity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        
        favoriteProductEntity.properties = [favoriteProductId]
        
        managedObjects.entities = [cartProductEntity,
                                   favoriteProductEntity]
        
        let container = NSPersistentContainer(name: CoreDataConstanst.dataName,
                                              managedObjectModel: managedObjects)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Error at core data: " + error.localizedDescription)
            }
        }
        
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Main Save
    private func saveContext(saveType: SaveType ) {
        guard context.hasChanges
        else { return }
        
        do {
            try context.save()
            switch saveType {
            case .favorite:
                NotificationCenter.default.post(name: .favoriteChange, object: nil)
            case .cart:
                NotificationCenter.default.post(name: .cartChange, object: nil)
            }
        } catch {
            let error = error as NSError
            fatalError("CoreData save error: " + error.localizedDescription)
        }
        
    }
    
    // MARK: - Favorite
    func saveFavoriteProduct(id: Int) {
        guard getFavoriteProduct(id: id) == nil
        else {
            deleteFavoriteItem(id: id)
            return
        }
        
        let allItems = NSEntityDescription.entity(forEntityName: CoreDataConstanst.favoriteEntityName,
                                                  in: context)!
        let newItem = NSManagedObject(entity: allItems,
                                      insertInto: context)
        newItem.setValue(id, forKey: CoreDataConstanst.productId)
        
        saveContext(saveType: .favorite)
    }
    
    func getFavoriteProducts() -> [Int] {
        let request = NSFetchRequest<NSManagedObject>(entityName: CoreDataConstanst.favoriteEntityName)
        do {
            let objects = try context.fetch(request)
            return objects.compactMap { product in
                return product.value(forKey: CoreDataConstanst.productId) as? Int
            }
        } catch {
            print("Error fetching favorite items: " + error.localizedDescription)
            return []
        }
    }
    
    private func getFavoriteProduct(id: Int) -> NSManagedObject? {
        let request = NSFetchRequest<NSManagedObject>(entityName: CoreDataConstanst.favoriteEntityName)
        request.predicate = NSPredicate(format: "Id == %d", id)
        request.fetchLimit = 1
        
        do {
            let items = try context.fetch(request)
            return items.first
        } catch {
            print("Error fetching favorite item: " + error.localizedDescription)
            return nil
        }
    }
    
    func deleteFavoriteItem(id: Int) {
        if let item = getFavoriteProduct(id: id) {
            context.delete(item)
            saveContext(saveType: .favorite)
        }
    }
    
    // MARK: - Product
    func saveCartProduct(id: Int) {
        if let existingItem = getCartProduct(id: id) {
            let quantity = existingItem.value(forKey: CoreDataConstanst.productQuantity) as? Int
            
            existingItem.setValue((quantity ?? -1) + 1, forKey: CoreDataConstanst.productQuantity)
        } else {
            let cartPorducts = NSEntityDescription.entity(forEntityName: CoreDataConstanst.cartEntityName,
                                                          in: context)!
            let newCartProduct = NSManagedObject(entity: cartPorducts, insertInto: context)
            newCartProduct.setValue(id, forKey: CoreDataConstanst.productId)
            newCartProduct.setValue(1, forKey: CoreDataConstanst.productQuantity)
        }
        
        saveContext(saveType: .cart)
    }
    
    func getCartProducts() -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: CoreDataConstanst.cartEntityName)
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching cart Products: " + error.localizedDescription)
            return []
        }
        
    }
    
    private func getCartProduct(id: Int) -> NSManagedObject? {
        let request = NSFetchRequest<NSManagedObject>(entityName: CoreDataConstanst.cartEntityName)
        request.predicate = NSPredicate(format: "Id == %d", id)
        request.fetchLimit = 1
        
        do {
            let items = try context.fetch(request)
            return items.first
        } catch {
            print("Error fetching cart item: " + error.localizedDescription)
            return nil
        }
        
    }
    
    func deleteCartProduct(id: Int) {
        if let item = getCartProduct(id: id) {
            context.delete(item)
            saveContext(saveType: .cart)
        }
        
    }
    
}

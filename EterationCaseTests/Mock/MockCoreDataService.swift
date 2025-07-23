//
//  MockCoreDataService.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 23.07.2025.
//

import XCTest
@testable import EterationCase

final class MockCoreDataService: CoreDataService {
    var savedFavoriteProducts: [Int] = []
    var cartProdcuts: [CartModel] = []
    
    func saveFavoriteProduct(id: Int) {
        guard !savedFavoriteProducts.contains(id)
        else {
            deleteFavoriteItem(id: id)
            return
        }
        
        savedFavoriteProducts.append(id)
        postChange(saveType: .favorite)
    }
    
    func getFavoriteProducts() -> [Int] {
        return savedFavoriteProducts
    }
    
    func deleteFavoriteItem(id: Int) {
        guard let index = savedFavoriteProducts.firstIndex(where: { $0 == id})
        else {
            XCTFail("could not found item in favorites")
            return
        }
        
        savedFavoriteProducts.remove(at: index)
        postChange(saveType: .favorite)
    }
    
    func addCartProduct(id: Int) {
        if let index = cartProdcuts.firstIndex(where: { $0.id == id}) {
            let newProduct: CartModel = CartModel(id: id,
                                                  quantity: cartProdcuts[index].quantity + 1,
                                                  product: nil)
            cartProdcuts[index] = newProduct
        } else {
            cartProdcuts.append(.init(id: id,
                                      quantity: 1,
                                      product: nil))
        }
        
        postChange(saveType: .cart)
    }
    
    func getCartProducts() -> [CartModel] {
        return cartProdcuts
    }
    
    func removeCartProduct(id: Int) {
        guard let index = cartProdcuts.firstIndex(where: { $0.id == id})
        else {
            XCTFail("could not found item in cartProduct")
            return
        }
        
        let quantity = cartProdcuts[index].quantity
        if quantity == 1 {
            cartProdcuts.remove(at: index)
        } else {
            let newProduct: CartModel = CartModel(id: id,
                                                  quantity: cartProdcuts[index].quantity - 1,
                                                  product: nil)
            cartProdcuts[index] = newProduct
        }
        
        postChange(saveType: .cart)
    }
    
    func deleteCartProduct(id: Int) {
        guard let index = cartProdcuts.firstIndex(where: { $0.id == id})
        else {
            XCTFail("could not found item in cartProduct")
            return
        }
        
        cartProdcuts.remove(at: index)
        postChange(saveType: .cart)
    }
    
    func deleteAllCartProducts() {
        cartProdcuts.removeAll()
        postChange(saveType: .cart)
    }
    
    private func postChange(saveType: SaveType) {
        switch saveType {
        case .favorite:
            NotificationCenter.default.post(name: .favoriteChange, object: nil)
        case .cart:
            NotificationCenter.default.post(name: .cartChange, object: nil)
        }
        
    }
    
}

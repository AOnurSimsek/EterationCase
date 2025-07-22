//
//  CartViewModel.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

import Foundation

protocol CartViewModel: AnyObject {
    func getCartProducts()
    func getRowCont() -> Int
    func getCellData(for index: Int) -> CartModel
    func getTotalPrice() -> Double
    func didPressReduceButton(for id: Int)
    func didPressAddButton(for id: Int)
    func deleteProduct(at index: Int)
    func completeShopping()
}

final class CartViewModelImpl: CartViewModel {
    private let coreDataService: CoreDataService
    private let productService: ProductService
    private var cartData: [CartModel] = []
    
    private let updateQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "cartUpdatehQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    private weak var view: CarViewModelDelegate?
    
    init(coreDataService: CoreDataService,
         productService: ProductService) {
        self.coreDataService = coreDataService
        self.productService = productService
        addNotificationObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(cartChanged),
                                               name: .cartChange, object: nil)
    }

    @objc private func cartChanged() {
        getCartProducts()
    }
    
    func setView(_ view: CarViewModelDelegate) {
        self.view = view
    }
    
    func getCartProducts() {
        view?.loadingStatus(isLoading: true)
        
        productService.getAllProducts { [weak self] result in
            guard let self = self
            else { return }
            
            switch result {
            case .success(let products):
                let cartItems = coreDataService.getCartProducts()
                
                self.cartData = cartItems.compactMap { cartProduct in
                    guard let baseProduct = products.first(where: { $0.id == cartProduct.id })
                    else { return nil }
                    
                    let neWModel: CartModel = .init(id: cartProduct.id,
                                                    quantity: cartProduct.quantity,
                                                    product: baseProduct)
                    return neWModel
                }
                
                self.cartData.sort { $0.id > $1.id }
            case .failure(let error):
                view?.showAlert(with: error.description)
            }
            
            self.view?.loadingStatus(isLoading: false)
            self.view?.reloadData()
        }
        
    }
    
    func getRowCont() -> Int {
        return cartData.count
    }
    
    func getCellData(for index: Int) -> CartModel {
        return cartData[index]
    }
    
    func getTotalPrice() -> Double {
        let total = cartData.compactMap { item in
            guard let price = item.product?.price else { return nil }
            return price * Double(item.quantity)
        }.reduce(0.0, +)
        
        return total
    }
    
    func didPressReduceButton(for id: Int) {
        coreDataService.removeCartProduct(id: id)
    }
    
    func didPressAddButton(for id: Int) {
        coreDataService.addCartProduct(id: id)
    }
    
    func deleteProduct(at index: Int) {
        let product = cartData[index]
        coreDataService.deleteCartProduct(id: product.id)
    }
    
    func completeShopping() {
        
    }
    
}


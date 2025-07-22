//
//  HomeViewModel.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

import Foundation

protocol HomeViewModel: AnyObject {
    func getProductData()
    func getRowCont() -> Int
    func getCellData(for index: Int) -> ProductModel
    func didPressAddtoCart(for id: Int)
    func didPressFavorite(for id: Int)
}

final class HomeViewModelImpl: HomeViewModel {
    private var productData: [ProductModel] = []
    private var filteredProductData: [ProductModel] = []
    private let service: ProductService
    private let coreDataService: CoreDataService
    private weak var view: HomeViewModelDelegate?
    
    init(service: ProductService,
         coreDataService: CoreDataService) {
        self.service = service
        self.coreDataService = coreDataService
        addNotificationObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesChanged),
                                               name: .favoriteChange, object: nil)
    }

    @objc private func favoritesChanged() {
        let ids = coreDataService.getFavoriteProducts()
        let idSet = Set(ids)
        
        productData = productData.map { product in
            var newProduct = product
            newProduct.isFavorite = idSet.contains(product.id ?? -2)
            return newProduct
        }
        
        filteredProductData = filteredProductData.map { product in
            var newProduct = product
            newProduct.isFavorite = idSet.contains(product.id ?? -2)
            return newProduct
        }
        
        view?.reloadData()
        
    }
    
    func setView(_ view: HomeViewModelDelegate) {
        self.view = view
    }
    
    func getProductData() {
        view?.loadingStatus(isLoading: true)
        
        service.getAllProducts { [weak self] result in
            guard let self = self
            else { return }
            
            switch result {
            case .success(let products):
                let ids = coreDataService.getFavoriteProducts()
                let idSet = Set(ids)
                
                productData = products.map { product in
                    var newProduct = product
                    newProduct.isFavorite = idSet.contains(product.id ?? -2)
                    return newProduct
                }
            case .failure(let error):
                view?.showAlert(with: error.description)
            }
            
            self.view?.loadingStatus(isLoading: false)
            self.view?.reloadData()
        }
        
    }
    
    func getRowCont() -> Int {
        return filteredProductData.isEmpty ? productData.count : filteredProductData.count
    }
    
    func getCellData(for index: Int) -> ProductModel {
        return filteredProductData.isEmpty ? productData[index] : filteredProductData[index]
    }
    
    func didPressAddtoCart(for id: Int) {
        coreDataService.saveCartProduct(id: id)
    }
    
    func didPressFavorite(for id: Int) {
        coreDataService.saveFavoriteProduct(id: id)
    }
    
}

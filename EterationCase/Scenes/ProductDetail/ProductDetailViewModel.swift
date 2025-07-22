//
//  ProductDetailViewModel.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

import Foundation

protocol ProductDetailViewModel: AnyObject {
    func getProductData()
    func didPressAddtoCart()
    func didPressFavorite()
}

final class ProductDetailViewModelImpl: ProductDetailViewModel {
    private var data: ProductModel
    private let coreDataService: CoreDataService

    private weak var view: ProductDetailViewModelDelegate?
    
    init(data: ProductModel,
         coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        self.data = data
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
        
        data.isFavorite = idSet.contains(data.id ?? -2)
        view?.reloadData(with: data)
    }
    
    func setView(_ view: ProductDetailViewModelDelegate) {
        self.view = view
    }
    
    func getProductData() {
        view?.loadingStatus(isLoading: true)
        view?.reloadData(with: data)
        view?.loadingStatus(isLoading: false)
    }
    
    func didPressAddtoCart() {
        guard let id = data.id
        else { return }
        
        coreDataService.saveCartProduct(id: id)
    }
    
    func didPressFavorite() {
        guard let id = data.id
        else { return }
        
        coreDataService.saveFavoriteProduct(id: id)
    }
    
}

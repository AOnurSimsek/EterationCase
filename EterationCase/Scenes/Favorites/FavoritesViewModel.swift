//
//  FavoritesViewModel.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

import Foundation

protocol FavoritesViewModel: AnyObject {
    func getFavoriteProducts()
    func getRowCont() -> Int
    func getCellData(for index: Int) -> ProductModel
    func didPressAddtoCart(for id: Int)
    func didPressFavorite(for id: Int)
}

final class FavoritesViewModelImpl: FavoritesViewModel {
    private var favoriteProducts: [ProductModel] = []
    private let service: ProductService
    private weak var view: FavoriteViewModelDelegate?
    private var coreDataService: CoreDataService

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
        getFavoriteProducts()
    }
    
    func setView(_ view: FavoriteViewModelDelegate) {
        self.view = view
    }
    
    func getFavoriteProducts() {
        view?.loadingStatus(isLoading: true)
        let ids = coreDataService.getFavoriteProducts()
        let idSet = Set(ids)
        guard !idSet.isEmpty
        else {
            favoriteProducts.removeAll()
            view?.reloadData()
            view?.loadingStatus(isLoading: false)
            return
        }
        
        service.getAllProducts { [weak self] result in
            guard let self = self
            else { return }
            
            switch result {
            case .success(let data):
                let filteredData = data.filter { idSet.contains($0.id ?? -2) }
                favoriteProducts = filteredData.map { product in
                    var newProduct = product
                    newProduct.isFavorite = true
                    return newProduct
                }
                self.view?.reloadData()
            case .failure(let error):
                self.view?.showAlert(with: error.description)
            }
        }
        
        view?.loadingStatus(isLoading: false)
    }
    
    func getRowCont() -> Int {
        return favoriteProducts.count
    }
    
    func getCellData(for index: Int) -> ProductModel {
        return favoriteProducts[index]
    }
    
    func didPressAddtoCart(for id: Int) {
        coreDataService.addCartProduct(id: id)
    }
    
    func didPressFavorite(for id: Int) {
        coreDataService.deleteFavoriteItem(id: id)
    }
    
}

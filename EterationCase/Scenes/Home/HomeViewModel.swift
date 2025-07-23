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
    func getAllproductData() -> [ProductModel]
    func searchTextAdded(text: String)
    func getSelectedFilters() -> [FilterModel]
    func didSelectFilter(selections: [FilterModel])
}

final class HomeViewModelImpl: HomeViewModel {
    private var productData: [ProductModel] = []
    private var filteredProductData: [ProductModel] = []
    private let service: ProductService
    private let coreDataService: CoreDataService
    private var searchText: String?
    private var searchQueue: DispatchQueue = .init(label: "search.queue",
                                                   qos: .userInitiated)
    private var searchTask: DispatchWorkItem?
    private weak var view: HomeViewModelDelegate?
    private var selectedFilters: [FilterModel] = []
    
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
    
    private func startSearch(text: String) {
        searchTask?.cancel()
        let searchTask: DispatchWorkItem = .init {
            self.view?.loadingStatus(isLoading: true)
            self.search()
            self.view?.reloadData()
            self.view?.loadingStatus(isLoading: false)
        }
        
        self.searchTask = searchTask
        searchQueue.asyncAfter(deadline: .now() + .milliseconds(200),
                               execute: searchTask)
        
    }
    
    private func search() {
        guard let text = searchText
        else { return }
        
        if self.filteredProductData.isEmpty {
            self.filteredProductData = self.productData
        }
        
        self.filteredProductData = self.filteredProductData.filter { ($0.name ?? "-").localizedCaseInsensitiveContains(text) ||
            ($0.model ?? "-").localizedCaseInsensitiveContains(text) ||
            ($0.brand ?? "-").localizedCaseInsensitiveContains(text) }
        
    }
    
    private func filterData() {
        view?.loadingStatus(isLoading: true)
        
        var newProductArray: [ProductModel] = []
        
        selectedFilters.forEach { filter in
            guard let selectedFilters = filter.selectedFilters
            else { return }
            
            switch filter.type {
            case .sort:
                return
            case .brand:
                let filteredProducts = productData.filter { selectedFilters.contains($0.brand ?? "") }
                newProductArray.append(contentsOf: filteredProducts)
            case .model:
                let filteredProducts = productData.filter { selectedFilters.contains($0.model ?? "") }
                newProductArray.append(contentsOf: filteredProducts)
            }
            
        }
        
        if let sortType = selectedFilters.first(where: { $0.type == .sort })?.selectedFilters,
           let selectedSortType = DataSortTypes(rawValue: sortType.first ?? "") {
            switch selectedSortType {
            case .oldtoNew:
                newProductArray.isEmpty ? productData.sort { ($0.createdAt ?? "").toISODate() < ($1.createdAt ?? "").toISODate() } : newProductArray.sort { ($0.createdAt ?? "").toISODate() < ($1.createdAt ?? "").toISODate()}
            case .newtoOld:
                newProductArray.isEmpty ? productData.sort { ($0.createdAt ?? "").toISODate() > ($1.createdAt ?? "").toISODate() } : newProductArray.sort { ($0.createdAt ?? "").toISODate() > ($1.createdAt ?? "").toISODate()}
            case .hightoLow:
                newProductArray.isEmpty ? productData.sort { $0.price ?? 0 > $1.price ?? 0 } : newProductArray.sort { $0.price ?? 0 > $1.price ?? 0 }
            case .lowtoHigh:
                newProductArray.isEmpty ? productData.sort { $0.price ?? 0 < $1.price ?? 0 } : newProductArray.sort { $0.price ?? 0 > $1.price ?? 0 }
            }
            
        }
        
        if !newProductArray.isEmpty {
            filteredProductData = newProductArray
        } else {
            filteredProductData.removeAll()
        }
        
        if searchText != nil {
            search()
        }

        view?.reloadData()
        view?.loadingStatus(isLoading: false)
        
    }
    
    // MARK: - Getters
    func getRowCont() -> Int {
        return filteredProductData.isEmpty ? productData.count : filteredProductData.count
    }
    
    func getCellData(for index: Int) -> ProductModel {
        return filteredProductData.isEmpty ? productData[index] : filteredProductData[index]
    }
    
    func getAllproductData() -> [ProductModel] {
        return productData
    }
    
    func getSelectedFilters() -> [FilterModel] {
        return selectedFilters
    }
    
    // MARK: - Input Handlers
    func searchTextAdded(text: String) {
        let spaceDeletedText = text.replacingOccurrences(of: " ", with: "")
        if spaceDeletedText != "",
           spaceDeletedText.count > 1 {
            searchText = text
            startSearch(text: text)
        } else if spaceDeletedText == "" {
            searchText = nil
            let isFilterSelectionEmpty = selectedFilters.allSatisfy { ($0.selectedFilters ?? []).isEmpty }
            if isFilterSelectionEmpty {
                filteredProductData.removeAll()
                view?.reloadData()
            } else {
                filterData()
            }
            
        }
        
    }
    
    func didSelectFilter(selections: [FilterModel]) {
        guard selections != selectedFilters
        else { return }
        
        self.selectedFilters = selections
        filterData()
    }
    
    func didPressAddtoCart(for id: Int) {
        coreDataService.addCartProduct(id: id)
    }
    
    func didPressFavorite(for id: Int) {
        coreDataService.saveFavoriteProduct(id: id)
    }
    
}

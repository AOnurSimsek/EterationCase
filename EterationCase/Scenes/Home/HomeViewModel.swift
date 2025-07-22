//
//  HomeViewModel.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

protocol HomeViewModel: AnyObject {
    func getProductData()
    func getRowCont() -> Int
    func getCellData(for index: Int) -> ProductModel
    func didPressAddtoCart(for id: Int)
    func didPressAddtoFavorite(for id: Int)
}

final class HomeViewModelImpl: HomeViewModel {
    private var productData: [ProductModel] = []
    private var filteredProductData: [ProductModel] = []
    private let service: ProductService
    private weak var view: HomeViewModelDelegate?
    
    init(service: ProductService) {
        self.service = service
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
                productData = products
            case .failure(let error):
                print("Error handling")
            }
            
            self.view?.loadingStatus(isLoading: false)
            self.view?.reloadData()
        }
        
    }
    
    func getRowCont() -> Int {
        filteredProductData.isEmpty ? productData.count : filteredProductData.count
    }
    
    func getCellData(for index: Int) -> ProductModel {
        filteredProductData.isEmpty ? productData[index] : filteredProductData[index]
    }
    
    func didPressAddtoCart(for id: Int) {
        
    }
    
    func didPressAddtoFavorite(for id: Int) {
        
    }
    
}

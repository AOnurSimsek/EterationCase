//
//  ProductDetailViewModel.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

protocol ProductDetailViewModel: AnyObject {
    func getProductData()
    func didPressAddtoCart()
    func didPressAddtoFavorite()
}

final class ProductDetailViewModelImpl: ProductDetailViewModel {
    private let data: ProductModel
    private weak var view: ProductDetailViewModelDelegate?
    
    init(data: ProductModel) {
        self.data = data
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
        
    }
    
    func didPressAddtoFavorite() {
        
    }
    
}

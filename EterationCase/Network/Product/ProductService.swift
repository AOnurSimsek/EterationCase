//
//  ProductService.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

import Foundation

protocol ProductService: AnyObject {
    func getAllProducts(completion: @escaping (Result<[ProductModel], APIError>) -> Void)
}

final class ProductServiceImp: ProductService {
    private let service = APIService.shared

    func getAllProducts(completion: @escaping (Result<[ProductModel], APIError>) -> Void) {
        guard let request = ProductEndpoint.allProducts.request
        else { return }

        service.makeRequest(with: request,
                            responseModel: [ProductModel].self,
                            completion: completion)
    }
    
}

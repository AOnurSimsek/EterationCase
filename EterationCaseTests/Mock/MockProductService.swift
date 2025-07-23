//
//  MockProductService.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 23.07.2025.
//

import XCTest
@testable import EterationCase

final class MockProductService: ProductService {
    func getAllProducts(completion: @escaping (Result<[ProductModel], APIError>) -> Void) {
        guard let productData = Reader.read("MockData",
                                            type: [ProductModel].self)
        else {
            XCTFail("Response can not decoded")
            return
        }
        
        let data: Result<[ProductModel],APIError> = .success(productData)
        completion(data)
    }
    
}

final class MockProductSortedService: ProductService {
    func getAllProducts(completion: @escaping (Result<[ProductModel], APIError>) -> Void) {
        guard let productData = Reader.read("MockModelFilterData",
                                            type: [ProductModel].self)
        else {
            XCTFail("Response can not decoded")
            return
        }
        
        let data: Result<[ProductModel],APIError> = .success(productData)
        completion(data)
    }
}

final class MockProductServiceFauilure: ProductService {
    func getAllProducts(completion: @escaping (Result<[ProductModel], APIError>) -> Void) {
        let error: Result<[ProductModel],APIError> = .failure(.unknownError("An unkown error"))
        completion(error)
    }
    
}

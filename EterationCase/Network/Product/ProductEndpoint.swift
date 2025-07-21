//
//  ProductEndpoint.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

import Foundation

enum ProductEndpoint: BaseEndpoint {
    case allProducts
    
    var request: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        return request
    }
    
    var path: String {
        switch self {
        case .allProducts:
            return "/products"
        }
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseURL
        components.port = nil
        components.path = self.path
        if !self.queryItems.isEmpty{
            components.queryItems = self.queryItems
        }
        
        return components.url
    }
    
     var httpMethod: String {
        switch self {
        case .allProducts:
            return HTTPMethods.get.rawValue
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .allProducts:
            return []
        }
    }
    
}

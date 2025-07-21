//
//  APIService.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

import Foundation

protocol Service {
    func makeRequest<T:Decodable>(with request: URLRequest,
                                  responseModel: T.Type,
                                  completion: @escaping (Result<T, APIError>) -> Void)
}

final class APIService: Service {
    static let shared = APIService()
    
    private let cache = NSCache<NSString, AnyObject>()

    func makeRequest<T: Decodable>(with request: URLRequest,
                                   responseModel: T.Type,
                                   completion: @escaping (Result<T, APIError>) -> Void) {
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error {
                completion(.failure(.urlSessionError(error.localizedDescription)))
                return
            }

            if let response = response as? HTTPURLResponse,
               (response.statusCode != 200) {
                completion(.failure(.serverError()))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(.invalidResponse()))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch let error {
                print("Error at service call " + error.localizedDescription )
                completion(.failure(.decodingError()))
                return
            }
        }.resume()
        
    }
}

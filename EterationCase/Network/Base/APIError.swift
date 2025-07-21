//
//  APIError.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

enum APIError: Error {
    case urlSessionError(String)
    case serverError(String = "Has unknown problem from server")
    case invalidResponse(String = "Invalid response from server")
    case decodingError(String = "Error parsing server response")
    case unknownError(String = "An unknown error occured. Try again later")
    case networkError(String = "An error at network connection. Check your connection and try again later")
    
    var description: String {
        switch self {
        case .urlSessionError(let message),
             .serverError(let message),
             .invalidResponse(let message),
             .decodingError(let message),
             .unknownError(let message),
             .networkError(let message):
            return message
            
        }
        
    }
    
}

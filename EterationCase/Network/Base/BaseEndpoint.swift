//
//  BaseEndpoint.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

import Foundation

protocol BaseEndpoint {
    var request: URLRequest? { get }
    var path: String { get }
    var url: URL? { get }
    var queryItems: [URLQueryItem] { get }
    var httpMethod: String { get }
}

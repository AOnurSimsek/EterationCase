//
//  Equatables.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 23.07.2025.
//

import Foundation
@testable import EterationCase

// MARK: - Responses
extension ProductModel: @retroactive Equatable {
    public static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        let id = lhs.id == rhs.id
        let name = lhs.name == rhs.name
        let brand = lhs.brand == rhs.brand
        
        return id && name && brand
    }
    
}

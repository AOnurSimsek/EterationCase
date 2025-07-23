//
//  FilterMainTypes.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

enum FilterMainTypes {
    case sort
    case brand
    case model
    
    var title: String {
        switch self {
        case .sort:
            return "Sort by"
        case .brand:
            return "Brand"
        case .model:
            return "Model"
        }
    }
    
}

struct FilterModel: Equatable {
    let type: FilterMainTypes
    var titles: [String]
    var selectedFilters: [String]? = []
}

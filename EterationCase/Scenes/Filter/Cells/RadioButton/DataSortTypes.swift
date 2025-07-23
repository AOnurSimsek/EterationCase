//
//  DataSortTypes.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

enum DataSortTypes:String,
                   CaseIterable {
    case oldtoNew = "Old to new"
    case newtoOld = "New to old"
    case hightoLow = "Price high to low"
    case lowtoHigh = "Price low to high"
    
    var title: String {
        switch self {
        case .oldtoNew:
            return "Old to new"
        case .newtoOld:
            return "New to old"
        case .hightoLow:
            return "Price high to low"
        case .lowtoHigh:
            return "Price low to high"
        }
    }
    
}

//
//  HomeViewMockController.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 23.07.2025.
//

import Foundation
@testable import EterationCase

final class HomeViewMockController: BaseViewController,
                                    HomeViewModelDelegate {
    var loadingVisibilty: [Bool] = .init()
    var reloadDataCount: Int = 0
    var data: [ProductModel] = []
    var alerts: [String] = .init()
    
    func loadingStatus(isLoading: Bool) {
        loadingVisibilty.append(isLoading)
    }
    
    func reloadData() {
        reloadDataCount += 1
    }
    
    func showAlert(with message: String) {
        alerts.append(message)
    }
    
    
}

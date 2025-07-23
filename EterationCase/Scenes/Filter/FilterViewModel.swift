//
//  FilterViewModel.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

import Foundation

protocol FilterDelegate: AnyObject {
    func didPressedApply(selectedFilters: [FilterModel])
}

protocol FilterViewModel: AnyObject {
    func getSectionCount() -> Int
    func getRowCount(for section: Int) -> Int
    func getCellData(for indexPath: IndexPath) -> FilterModel
    func getSectionType(for section: Int) -> FilterMainTypes
    func generateSections()
    func didSelectFilter(for type: FilterMainTypes,
                         title: String)
    func didDeselectFilter(for type: FilterMainTypes,
                           title: String)
    func didPressApply()
}

final class FilterViewModelImp: FilterViewModel {
    private let productData: [ProductModel]
    private var sectionData: [FilterModel] = []
    private let selectedFilters: [FilterModel]
    
    private weak var view: FilterViewModelDelegate?
    private weak var delegate: FilterDelegate?
    
    init(productData: [ProductModel],
         selectedFilters: [FilterModel],
         delegate: FilterDelegate) {
        self.productData = productData
        self.selectedFilters = selectedFilters
        self.delegate = delegate
    }
    
    func setView(_ view: FilterViewModelDelegate?) {
        self.view = view
    }
    
    func generateSections() {
        view?.loadingStatus(isLoading: true)
        
        sectionData.removeAll()
        
        let sortTitles: [String] = DataSortTypes.allCases.map { $0.title }
        let currentSortSelection = ((selectedFilters.first { $0.type == .sort })?.selectedFilters) ?? []
        let sortData: FilterModel = .init(type: .sort,
                                          titles: sortTitles,
                                          selectedFilters: currentSortSelection)
        sectionData.append(sortData)
        
        let brandNames: Set<String> = .init(productData.compactMap({ $0.brand}))
        let currentBrandSelection = ((selectedFilters.first { $0.type == .brand })?.selectedFilters) ?? []
        let brandData: FilterModel = .init(type: .brand,
                                           titles: Array(brandNames),
                                           selectedFilters: currentBrandSelection)
        sectionData.append(brandData)
        
        let modelNames: Set<String> = .init(productData.compactMap({ $0.model}))
        let currentModelSelection = ((selectedFilters.first { $0.type == .model })?.selectedFilters) ?? []
        let modelData: FilterModel = .init(type: .model,
                                           titles: Array(modelNames),
                                           selectedFilters: currentModelSelection)
        sectionData.append(modelData)
        
        view?.reloadData()
        view?.loadingStatus(isLoading: false)
    }
    
    func getSectionCount() -> Int {
        return sectionData.count
    }
    
    func getRowCount(for section: Int) -> Int {
        return 1
    }
    
    func getCellData(for indexPath: IndexPath) -> FilterModel {
        return sectionData[indexPath.section]
    }
    
    func getSectionType(for section: Int) -> FilterMainTypes {
        return sectionData[section].type
    }
    
    func didSelectFilter(for type: FilterMainTypes,
                         title: String) {
        guard let dataIndex = sectionData.firstIndex(where: { $0.type == type })
        else { return }
        
        sectionData[dataIndex].selectedFilters?.append(title)
    }
    
    func didDeselectFilter(for type: FilterMainTypes,
                           title: String) {
        guard let dataIndex = sectionData.firstIndex(where: { $0.type == type }),
              let index = sectionData[dataIndex].selectedFilters?.firstIndex(of: title)
        else { return }
        
        sectionData[dataIndex].selectedFilters?.remove(at: index)
    }
    
    func didPressApply() {
        delegate?.didPressedApply(selectedFilters: sectionData)
        view?.closeView()
    }
    
}

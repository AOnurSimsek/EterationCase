//
//  HomeViewModelTest.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 23.07.2025.
//

import XCTest
@testable import EterationCase

final class HomeViewModelTests: XCTestCase {
    private var controller: HomeViewMockController!
    private var sut: HomeViewModelImpl!
    private var productService: ProductService!
    private var coreDataService: CoreDataService!
    
    override func setUp() {
        super.setUp()
    }
    
    private func getsut(productService: ProductService) {
        coreDataService = MockCoreDataService()
        controller = HomeViewMockController()
        
        sut = HomeViewModelImpl(service: productService,
                                coreDataService: coreDataService)
        sut.setView(controller)
    }
    
    func testGetProductData() {
        let productService: ProductService = MockProductService()
        getsut(productService: productService)
        
        sut.getProductData()
        
        XCTAssertEqual(controller.loadingVisibilty.count, 2)
        XCTAssertEqual(controller.loadingVisibilty.first, true)
        XCTAssertEqual(controller.loadingVisibilty.last, false)
        XCTAssertEqual(controller.reloadDataCount, 1)
    }
    
    func testGetProductFailure() {
        let productService: ProductService = MockProductServiceFauilure()
        getsut(productService: productService)
        
        sut.getProductData()
        
        XCTAssertEqual(controller.loadingVisibilty.count, 2)
        XCTAssertEqual(controller.loadingVisibilty.first, true)
        XCTAssertEqual(controller.loadingVisibilty.last, false)
        
        XCTAssertEqual(controller.reloadDataCount, 1)
        XCTAssertEqual(controller.alerts.first, "An unkown error")
        XCTAssertEqual(controller.alerts.count, 1)
    }
    
    func testGettersForAllData() {
        let productService: ProductService = MockProductService()
        getsut(productService: productService)
        
        guard let data = Reader.read("MockData",
                                     type: [ProductModel].self)
        else {
            XCTFail("Product data can not decoded")
            return
        }
        
        sut.getProductData()
        
        XCTAssertEqual(sut.getRowCont(), data.count)
        XCTAssertEqual(sut.getAllproductData(), data)
        XCTAssertEqual(sut.getCellData(for: 0), data.first)
        XCTAssertEqual(sut.getSelectedFilters(), [])
    }
    
    func testPressedFavorite() {
        let productService: ProductService = MockProductService()
        getsut(productService: productService)
        
        sut.getProductData()
        let firstCellID = sut.getCellData(for: 0).id
        sut.didPressFavorite(for: firstCellID ?? -1)
        XCTAssertEqual(sut.getCellData(for: 0).isFavorite, true)
        
        sut.didPressFavorite(for: firstCellID ?? -1)
        XCTAssertEqual(sut.getCellData(for: 0).isFavorite, false)
    }
    
    func testAddtoCart() {
        let productService: ProductService = MockProductService()
        getsut(productService: productService)
        
        sut.getProductData()
        let firstCellID = sut.getCellData(for: 0).id
        sut.didPressAddtoCart(for: firstCellID ?? -1)
        let cartData = coreDataService.getCartProducts().first?.id
        
        XCTAssertEqual(sut.getCellData(for: 0).id, cartData)
    }
    
    func testSearch() {
        let productService: ProductService = MockProductService()
        getsut(productService: productService)
        
        guard let data = Reader.read("MockSearchData",
                                     type: [ProductModel].self)
        else {
            XCTFail("Product data can not decoded")
            return
        }
        
        let expectation = XCTestExpectation(description: "Wait for search results")
        
        sut.getProductData()
        sut.searchTextAdded(text: "Bentley")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4.0)
        
        XCTAssertEqual(controller.loadingVisibilty.count, 4)
        XCTAssertEqual(controller.loadingVisibilty.first, true)
        XCTAssertEqual(controller.loadingVisibilty.last, false)
        XCTAssertEqual(controller.reloadDataCount, 2)
        
        XCTAssertEqual(sut.getCellData(for: 0), data.first)
        XCTAssertEqual(sut.getRowCont(), data.count)
    }
    
    func testEmptySearch() {
        let productService: ProductService = MockProductService()
        getsut(productService: productService)
        
        guard let data = Reader.read("MockData",
                                     type: [ProductModel].self)
        else {
            XCTFail("Product data can not decoded")
            return
        }
        
        let expectation = XCTestExpectation(description: "Wait for search results")
        
        sut.getProductData()
        sut.searchTextAdded(text: "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4.0)
        
        XCTAssertEqual(controller.loadingVisibilty.count, 2)
        XCTAssertEqual(controller.loadingVisibilty.first, true)
        XCTAssertEqual(controller.loadingVisibilty.last, false)
        XCTAssertEqual(controller.reloadDataCount, 2)
        
        XCTAssertEqual(sut.getCellData(for: 0), data.first)
        XCTAssertEqual(sut.getRowCont(), data.count)
    }
    
    func testBrandFilter() {
        let productService: ProductService = MockProductService()
        getsut(productService: productService)
        
        guard let data = Reader.read("MockBrandFilterData",
                                     type: [ProductModel].self)
        else {
            XCTFail("Product data can not decoded")
            return
        }
        
        let expectation = XCTestExpectation(description: "Wait for search results")
        
        sut.getProductData()
        sut.didSelectFilter(selections: [.init(type: .brand,
                                               titles: [],
                                               selectedFilters: ["Ford"])])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4.0)
        
        XCTAssertEqual(controller.loadingVisibilty.count, 4)
        XCTAssertEqual(controller.loadingVisibilty.first, true)
        XCTAssertEqual(controller.loadingVisibilty.last, false)
        XCTAssertEqual(controller.reloadDataCount, 2)
        
        XCTAssertEqual(sut.getCellData(for: 0), data.first)
        XCTAssertEqual(sut.getRowCont(), data.count)
    }
    
    func testModelFilter() {
        let productService: ProductService = MockProductService()
        getsut(productService: productService)
        
        guard let data = Reader.read("MockModelFilterData",
                                     type: [ProductModel].self)
        else {
            XCTFail("Product data can not decoded")
            return
        }
        
        let expectation = XCTestExpectation(description: "Wait for search results")
        
        sut.getProductData()
        sut.didSelectFilter(selections: [.init(type: .model,
                                               titles: [],
                                               selectedFilters: ["Wrangler"])])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4.0)
        
        XCTAssertEqual(controller.loadingVisibilty.count, 4)
        XCTAssertEqual(controller.loadingVisibilty.first, true)
        XCTAssertEqual(controller.loadingVisibilty.last, false)
        XCTAssertEqual(controller.reloadDataCount, 2)
        
        XCTAssertEqual(sut.getCellData(for: 0), data.first)
        XCTAssertEqual(sut.getRowCont(), data.count)
    }
    
    func testModelSort() {
        let productService: ProductService = MockProductSortedService()
        getsut(productService: productService)
        
        guard var data = Reader.read("MockModelFilterData",
                                     type: [ProductModel].self)
        else {
            XCTFail("Product data can not decoded")
            return
        }
        
        data.sort { $0.price ?? -1 < $1.price ?? -1 }

        let expectation = XCTestExpectation(description: "Wait for search results")
        
        sut.getProductData()
        sut.didSelectFilter(selections: [.init(type: .sort,
                                               titles: [],
                                               selectedFilters: ["Price low to high"])])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4.0)
        
        XCTAssertEqual(controller.loadingVisibilty.count, 4)
        XCTAssertEqual(controller.loadingVisibilty.first, true)
        XCTAssertEqual(controller.loadingVisibilty.last, false)
        XCTAssertEqual(controller.reloadDataCount, 2)
        
        XCTAssertEqual(sut.getCellData(for: 0), data.first)
        XCTAssertEqual(sut.getRowCont(), data.count)
    }
    
}

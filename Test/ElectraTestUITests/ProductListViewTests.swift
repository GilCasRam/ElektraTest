//
//  ProductListViewTests.swift
//  ElectraTestTests
//
//  Created by Gil Alfredo Casimiro Ramírez on 12/12/24.
//

import XCTest
import SwiftUI
@testable import ElectraTest

final class ProductListLogicTests: XCTestCase {
    var products: [Product]!
    var searchText: String!
    
    override func setUp() {
        super.setUp()
        products = [
            Product(id: "1", name: "Product A", images: [], finalPrice: 10.0),
            Product(id: "2", name: "Product B", images: [], finalPrice: 20.0),
            Product(id: "3", name: "Another Product", images: [], finalPrice: 30.0)
        ]
        searchText = ""
    }
    
    override func tearDown() {
        products = nil
        searchText = nil
        super.tearDown()
    }
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func testFilterProducts_EmptySearch() {
        // Given
        searchText = ""
        
        // When
        let result = filteredProducts
        
        // Then
        XCTAssertEqual(result.count, products.count)
    }
    
    func testFilterProducts_ValidSearch() {
        // Given
        searchText = "Product"
        
        // When
        let result = filteredProducts
        
        // Then
        XCTAssertEqual(result.count, 3)
    }
    
    func testFilterProducts_NoMatches() {
        // Given
        searchText = "Nonexistent"
        
        // When
        let result = filteredProducts
        
        // Then
        XCTAssertEqual(result.count, 0)
    }
}

//
//  ProductViewModelTests.swift
//  ElectraTestTests
//
//  Created by Gil Alfredo Casimiro Ramírez on 12/12/24.
//

import XCTest
@testable import ElectraTest

final class ProductViewModelTests: XCTestCase {
    var viewModel: ProductViewModel!
    var mockService: MockProductService!
    
    override func setUp() {
        super.setUp()
        mockService = MockProductService()
        viewModel = ProductViewModel(productService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchProducts_Success() {
        // Given
        mockService.mockProducts = [
            Product(id: "1", name: "Test Product", images: ["test.jpg"], finalPrice: 100.0)
        ]
        
        // When
        let expectation = XCTestExpectation(description: "Fetch products successfully")
        viewModel.fetchProducts()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.products.count, 1)
            XCTAssertEqual(self.viewModel.products.first?.name, "Test Product")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchProducts_Failure() {
        // Given
        mockService.shouldReturnError = true
        
        // When
        let expectation = XCTestExpectation(description: "Handle error gracefully")
        viewModel.fetchProducts()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.viewModel.errorMessage)
            XCTAssertEqual(self.viewModel.errorMessage?.message, "The operation couldn’t be completed. (TestError error -1.)")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testDecodeJSON_Success() {
        // Given
        let jsonData = """
        [
            {
                "id": "1",
                "idLinea": 10,
                "codigoCategoria": "cat1",
                "idModalidad": 5,
                "relevancia": 3,
                "pagoSemanalPrincipal": 200,
                "plazoPrincipal": 12,
                "disponibleCredito": true,
                "abonosSemanales": [
                    { "plazo": 12, "montoAbono": 150, "precio": 1800.0 }
                ],
                "nombre": "Producto Mock",
                "urlImagenes": ["imagen1.jpg"],
                "precioRegular": 1000.0,
                "precioFinal": 900.0
            }
        ]
        """.data(using: .utf8)!
        
        do {
            // When
            let products = try JSONDecoder().decode([Product].self, from: jsonData)
            
            // Then
            XCTAssertEqual(products.count, 1)
            XCTAssertEqual(products.first?.name, "Producto Mock")
            XCTAssertEqual(products.first?.finalPrice, 900.0)
        } catch {
            XCTFail("Error al decodificar JSON: \(error)")
        }
    }
}

//
//  MockProductService.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 12/12/24.
//

import Foundation

class MockProductService: ProductService {
    var shouldReturnError = false
    var mockProducts: [Product] = []
    
    override func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "TestError", code: -1, userInfo: nil)))
        } else {
            completion(.success(mockProducts))
        }
    }
}

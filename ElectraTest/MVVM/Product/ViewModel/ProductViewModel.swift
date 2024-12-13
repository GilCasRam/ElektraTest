//
//  ProductViewModel.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 12/12/24.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var errorMessage: ErrorWrapper? = nil
    @Published var searchText: String = ""
    @Published var isLoanding: Bool = false
    private let productService: ProductFetchingProtocol
    
    // Productos filtrados según la barra de búsqueda
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter { product in
                product.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    init(productService: ProductFetchingProtocol = ProductService()) {
        self.productService = productService
    }
    
    func fetchProducts() {
        self.isLoanding = true
        productService.fetchProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self?.products = products
                    self?.isLoanding = false
                case .failure(let error):
                    self?.errorMessage = ErrorWrapper(message: error.localizedDescription)
                    self?.isLoanding = false
                }
            }
        }
    }
}

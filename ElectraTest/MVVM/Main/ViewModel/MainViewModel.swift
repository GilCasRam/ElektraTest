//
//  MainViewModel.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/12/24.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var errorMessage: ErrorWrapper? = nil
    @Published var savedProducts: [ProductEntity] = []
    @Published var selectedProduct: Product? = nil
    @Published var showProductList = false
    @Published var showDuplicateAlert = false
    private let productService: ProductService
    
    init(productService: ProductService = ProductService()) {
        self.productService = productService
    }
    
    func fetchProducts() {
        productService.fetchProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self?.products = products
                case .failure(let error):
                    self?.errorMessage = ErrorWrapper(message: error.localizedDescription)
                }
            }
        }
    }
    // Método para cargar productos guardados desde Core Data
    func fetchSavedProducts() {
        savedProducts = ProductCoreDataManager.shared.fetchSavedProducts()
    }
    // Método para eliminar productos de Core Data
    func deleteProducts(at offsets: IndexSet) {
        offsets.forEach { index in
            let productToDelete = savedProducts[index]
            ProductCoreDataManager.shared.deleteProduct(productToDelete) // Eliminar de Core Data
        }
        fetchSavedProducts() // Actualizar la lista después de eliminar
    }
}


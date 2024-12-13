//
//  MainViewModel.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/12/24.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var savedProducts: [ProductEntity] = []
    @Published var selectedProduct: Product? = nil
    @Published var showProductList = false
    @Published var showDuplicateAlert = false
    
    private let repository: ProductRepositoryProtocol
    
    // Inicializador con inyección de dependencias
    init(repository: ProductRepositoryProtocol = ProductCoreDataManager.shared) {
        self.repository = repository
    }
    
    // Método para cargar productos guardados desde el repositorio
    func fetchSavedProducts() {
        savedProducts = repository.fetchSavedProducts()
    }
    
    // Método para eliminar productos utilizando el repositorio
    func deleteProducts(at offsets: IndexSet) {
        offsets.forEach { index in
            let productToDelete = savedProducts[index]
            repository.deleteProduct(productToDelete) // Usar el repositorio inyectado
        }
        fetchSavedProducts() // Actualizar la lista después de eliminar
    }
    
    // Método para guardar un producto con verificación de duplicados
    func saveProduct(_ product: Product) {
        if repository.isProductAlreadySaved(productId: product.id) {
            showDuplicateAlert = true // Mostrar alerta si el producto ya está guardado
        } else {
            repository.saveProduct(product: product)
            fetchSavedProducts() // Actualizar la lista de productos guardados
        }
    }
}

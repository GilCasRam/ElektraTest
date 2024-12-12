//
//  MainView.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/12/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var vm = MainViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                // Producto seleccionado
                if let product = vm.selectedProduct {
                    SelectedProductCell(
                        product: product,
                        onSave: {
                            if ProductCoreDataManager.shared.isProductAlreadySaved(productId: product.id) {
                                vm.showDuplicateAlert = true
                            } else {
                                ProductCoreDataManager.shared.saveProduct(product: product)
                                vm.fetchSavedProducts() // Actualizar la lista de productos guardados
                                vm.selectedProduct = nil // Limpiar el producto seleccionado
                            }
                        },
                        showDuplicateAlert: $vm.showDuplicateAlert
                    )
                } else {
                    Text("No hay producto seleccionado")
                        .foregroundColor(.gray)
                }
                Spacer()
                if !vm.savedProducts.isEmpty {
                    // Ver productos guardados
                    Text("Productos Guardados:")
                        .font(.headline)
                        .padding(.top)
                    SavedProductListCell(savedProducts: vm.savedProducts, onDelete: vm.deleteProducts)
                }
                Spacer()
                // Navegar a lista de productos
                NavigationLink(value: "productsList") {
                    Text("Ver Productos")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Productos")
            .navigationDestination(for: String.self) { destination in
                if destination == "productsList" {
                    ProductListView(selectedProduct: $vm.selectedProduct)
                }
            }
            .onAppear {
                vm.fetchSavedProducts() // Cargar productos guardados al abrir la vista
            }
        }
    }
}

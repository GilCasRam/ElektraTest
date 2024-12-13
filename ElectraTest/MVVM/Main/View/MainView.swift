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
                Text("Productos")
                    .padding()
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                // Producto seleccionado
                if let product = vm.selectedProduct {
                    SelectedProductCell(
                        product: product,
                        onSave: {
                            if ProductCoreDataManager.shared.isProductAlreadySaved(productId: product.id) {
                                vm.showDuplicateAlert = true
                            } else {
                                vm.saveProduct(product)
                                vm.fetchSavedProducts() // Actualizar la lista de productos guardados
                                // Limpiar el producto seleccionado
                            }
                        }, clean: {vm.selectedProduct = nil},
                        showDuplicateAlert: $vm.showDuplicateAlert
                    )
                } else {
                    Text("No hay producto seleccionado")
                        .foregroundColor(.gray)
                }
                Spacer()
                if !vm.savedProducts.isEmpty {
                    // Ver productos guardados
                    Text("Productos guardados:")
                        .font(.headline)
                        .padding(.top)
                    SavedProductListCell(savedProducts: vm.savedProducts, onDelete: vm.deleteProducts)
                }
                Spacer()
                // Navegar a lista de productos
                NavigationLink(value: "productsList") {
                    Text("Ver productos")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(10)
            }
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

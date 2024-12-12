//
//  MainView.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/12/24.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var vm = ProductViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                // Producto seleccionado
                if let product = vm.selectedProduct {
                    Text("Producto Seleccionado:")
                        .font(.headline)
                    AsyncImage(url: URL(string: product.images.first ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    Text(product.name)
                        .font(.subheadline)
                    Text("Precio Final: $\(product.finalPrice, specifier: "%.2f")")
                        .font(.subheadline)
                    
                    Button("Guardar Producto") {
                        if ProductCoreDataManager.shared.isProductAlreadySaved(productId: product.id) {
                            vm.showDuplicateAlert = true
                            
                        } else {
                            ProductCoreDataManager.shared.saveProduct(product: product)
                            vm.fetchSavedProducts() // Actualizar la lista de productos guardados
                            vm.selectedProduct = nil // Limpiar el producto seleccionado
                        }
                    }
                    .alert("Producto ya guardado", isPresented: $vm.showDuplicateAlert) {
                        Button("OK", role: .cancel) {vm.selectedProduct = nil}
                    }                .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
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
                    
                    List {
                        ForEach(vm.savedProducts, id: \.self) { savedProduct in
                            HStack {
                                AsyncImage(url: URL(string: savedProduct.imageURL ?? "")) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)

                                VStack(alignment: .leading) {
                                    Text(savedProduct.name ?? "Sin Nombre")
                                        .font(.subheadline)
                                    Text("Precio Final: $\(savedProduct.finalPrice, specifier: "%.2f")")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete(perform: vm.deleteProducts) // Mover el modificador aquí
                    }
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
                .padding()
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


//ScrollView(.horizontal) {
//    HStack{
//        ForEach(product.images, id: \.self) { imageURL in
//            AsyncImage(url: URL(string: imageURL)) { image in
//                image.resizable()
//            } placeholder: {
//                ProgressView()
//            }
//            .frame(width: 80, height: 80)
//            .cornerRadius(8)
//        }
//    }
//}.padding(.horizontal)


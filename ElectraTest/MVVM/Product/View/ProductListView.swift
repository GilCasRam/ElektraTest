//
//  ProductListView.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/12/24.
//

import SwiftUI

struct ProductListView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProductViewModel()
    @Binding var selectedProduct: Product?
    
    var body: some View {
        List(viewModel.filteredProducts) { product in
            Button(action: {
                selectedProduct = product
                if selectedProduct?.id != ""  {
                    dismiss()
                }
            }) {
                ProductCard(product: product)
            }
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Buscar producto")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(Color.init(hex: "DFF4F3")!, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .navigationTitle("Lista de productos")
        .onAppear {
            viewModel.fetchProducts()
        }
        .overlay(content: {
            if viewModel.isLoanding {
                ProgressView{
                    Text("Loading")
                        .foregroundColor(.blue)
                        .bold()
                }.padding()
                .background(Color.gray.opacity(0.2))
            }
        })
        .alert(item: $viewModel.errorMessage) { errorWrapper in
            Alert(
                title: Text("Error"),
                message: Text(errorWrapper.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

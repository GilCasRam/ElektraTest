//
//  ProductListView.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/12/24.
//

import SwiftUI
//import ViewInspector

struct ProductListView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = ProductViewModel()
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
        .toolbarBackground(Color.blue, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .navigationTitle("Lista de Productos")
        .onAppear {
            viewModel.fetchProducts()
        }
        .alert(item: $viewModel.errorMessage) { errorWrapper in
            Alert(
                title: Text("Error"),
                message: Text(errorWrapper.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

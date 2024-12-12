//
//  ProductListView.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/12/24.
//

import SwiftUI

struct ProductListView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = ProductViewModel()
    @Binding var selectedProduct: Product?
    
    var body: some View {
        List(viewModel.products) { product in
            Button(action: {
                selectedProduct = product
                if selectedProduct?.id != ""  {
                    dismiss()
                }
            }) {
                ProductCard(product: product)
            }
        }
        .navigationBarTitleDisplayMode(.large)
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

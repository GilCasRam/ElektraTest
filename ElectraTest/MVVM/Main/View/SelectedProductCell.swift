//
//  SelectedProductView.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 12/12/24.
//

import SwiftUI

struct SelectedProductCell: View {
    let product: Product
    let onSave: () -> Void
    @Binding var showDuplicateAlert: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Producto Seleccionado:")
                .font(.headline)
            
            if product.images.count > 1 {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(product.images, id: \.self) { imageURL in
                            AsyncImage(url: URL(string: imageURL)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
            } else {
                AsyncImage(url: URL(string: product.images.first ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            }
            
            Text(product.name)
                .font(.subheadline)
            
            Text("Precio Final: $\(product.finalPrice, specifier: "%.2f")")
                .font(.subheadline)
            
            Button("Guardar Producto") {
                onSave()
            }
            .alert("Producto ya guardado", isPresented: $showDuplicateAlert) {
                Button("OK", role: .cancel) {}
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

//
//  CardView.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/12/24.
//

import SwiftUI

struct ProductCard: View {
    let product: Product

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: product.images.first ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.headline)
                Text("Precio Regular: $\(product.regularPrice, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Precio Final: $\(product.finalPrice, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.green)
                Text("Crédito Disponible: \(product.creditAvailable ? "Sí" : "No")")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}


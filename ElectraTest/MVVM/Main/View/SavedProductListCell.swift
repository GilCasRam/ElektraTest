//
//  SavedProductListCell.swift
//  ElectraTest
//
//  Created by Gil Alfredo Casimiro Ramírez on 12/12/24.
//

import SwiftUI

struct SavedProductListCell: View {
    let savedProducts: [ProductEntity]
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(savedProducts, id: \.self) { savedProduct in
                HStack {
                    AsyncImage(url: URL(string: savedProduct.imageURL ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text(savedProduct.name ?? "Sin nombre")
                            .font(.subheadline)
                        Text("Precio final: $\(savedProduct.finalPrice, specifier: "%.2f")")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onDelete(perform: onDelete)
        }
    }
}

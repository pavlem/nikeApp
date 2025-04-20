//
//  ProductGridCell.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import SwiftUI

struct ProductGridCell: View {
    
    let product: Product

    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: product.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(8)

            Text(product.title)
                .font(.headline)
                .lineLimit(2)

            Text(String(format: "$%.2f", product.price))
                .font(.subheadline)

            Text(product.category)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}

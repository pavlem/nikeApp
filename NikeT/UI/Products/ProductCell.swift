//
//  ProductCell.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 19. 4. 2025..
//

import SwiftUI

struct ProductCell: View {
    
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(product.title)
                .font(.headline)
            Text(String(format: "$%.2f", product.price))
                .font(.subheadline)
            Text(product.description)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

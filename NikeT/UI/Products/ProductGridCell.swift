//
//  ProductGridCell.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import SwiftUI

struct ProductGridCell: View {
    
    let product: Product // we can also introduce a ViewModel here, but it's a simple View and there is no need.
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: Constants.vSpacing) {
            AsyncImage(url: product.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
            } placeholder: {
                Color.gray.opacity(Constants.placeholderColorOpacity)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(Constants.imageCornerRadius)
            
            Text(product.title)
                .font(.headline)
                .lineLimit(Constants.titleLineLimit)
            
            Text(String(format: "$%.2f", product.price))
                .font(.subheadline)
            
            Text(product.category)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(Constants.cardCornerRadius)
        .shadow(color: Constants.shadowColor, radius: Constants.shadowRadius, x: Constants.shadowX, y: Constants.shadowY)
    }
}

extension ProductGridCell {
    struct Constants {
        static var vSpacing: CGFloat = 8
        static var imageCornerRadius: CGFloat = 8
        static var cardCornerRadius: CGFloat = 12
        static var shadowColor: Color = .black.opacity(0.15)
        static var shadowRadius: CGFloat = 4
        static var shadowX: CGFloat = 0
        static var shadowY: CGFloat = 2
        static var titleLineLimit: Int = 2
        static var placeholderColorOpacity = 0.3
    }
}

//
//  ProductDetailsView.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 18. 4. 2025..
//

import SwiftUI

struct ProductDetailsView: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(product.title)
                .font(.largeTitle)
            Text(String(format: "$%.2f", product.price))
                .font(.title2)
            Text(product.description)
                .padding(.top)
        }
        .padding()
        .navigationTitle(Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension ProductDetailsView {
    struct Constants {
        static var navigationTitle: LocalizedStringKey { "Details" }
    }
}

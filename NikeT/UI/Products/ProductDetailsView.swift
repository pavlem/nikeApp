//
//  ProductDetailsView.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 18. 4. 2025..
//

import SwiftUI
import SwiftData

@MainActor
struct ProductDetailsView: View {
    
    let product: Product
    
    @State private var isZoomPresented = false
    @Environment(\.modelContext) private var modelContext
    @Query private var cartItems: [CartItem]

    private var isInCart: Bool {
        if cartItems.first(where: { $0.id == product.id }) != nil {
            return true
        } else {
            return false
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = product.imageURL {
                    Button {
                        isZoomPresented = true
                    } label: {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                    }
                    .fullScreenCover(isPresented: $isZoomPresented) {
                        ZoomableImageView(imageURL: url)
                    }
                }

                Text(product.title)
                    .font(.title)
                    .bold()

                HStack(spacing: 16) {
                    
                    Text(String(format: "$%.2f", product.price))
                        .font(.title2)
                    
                    Spacer()
                    
                    Button(action: {
                        
                        
                        if let existing = cartItems.first(where: { $0.id == product.id }) {
                            modelContext.delete(existing)
//                            print("Cart items in DB:", cartItems.map(\.id))

                        } else {
                            modelContext.insert(CartItem(product: product))
//                            print("Cart items in DB:", cartItems.map(\.id))

                        }
                        

                        

                    }) {
                        Text(isInCart ? "Remove from Cart" : "Add to Cart")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(isInCart ? Color.red : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= Int(round(product.rating.rate)) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                    Text("(\(product.rating.count))")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }

                Text("Category: \(product.category)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(product.description)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle(Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension ProductDetailsView {
    struct Constants {
        static var navigationTitle: LocalizedStringKey { "Details" }
    }
}

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
    
    @StateObject var viewModel: ProductDetailsViewModelImpl
    
    @Environment(\.modelContext) private var modelContext
    @Query private var cartItems: [CartItem]
    
    private var isInCart: Bool {
        if viewModel.isInCart(cartItems: cartItems) {
            return true
        }
        return false
    }
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 16) {
                
                if let url = viewModel.imageURL {
                    
                    Button {
                        viewModel.isZoomPresented = true
                    } label: {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                    }
                    .fullScreenCover(isPresented: $viewModel.isZoomPresented) {
                        ZoomableImageView(imageURL: url)
                    }
                }
                
                Text(viewModel.productTitle)
                    .font(.title)
                    .bold()
                
                HStack(spacing: 16) {
                    
                    Text(viewModel.priceText)
                        .font(.title2)
                    
                    Spacer()
                    
                    Button(action: {
                        if let existing = viewModel.existingCartItem(cartItems: cartItems) {
                            modelContext.delete(existing)
                        } else {
                            modelContext.insert(CartItem(product: viewModel.product))
                        }
                        
                        print("Cart items in DB:", cartItems.map(\.id))
                        
                    }) {
                        Text(viewModel.buttonTitle(cartItems: cartItems))
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(viewModel.buttonColor(cartItems: cartItems))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { index in
                        
                        Image(systemName: viewModel.imageName(forIndex: index))
                            .foregroundColor(.yellow)
                    }
                    Text(viewModel.ratingCountText)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                Text(viewModel.categoryText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(viewModel.descriptionText)
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

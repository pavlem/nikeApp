//
//  ProductDetailsView.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 18. 4. 2025..
//

import SwiftUI
import SwiftData

struct ProductDetailsView: View {
    let product: Product
    @State private var isZoomPresented = false
    @Environment(\.modelContext) private var modelContext
    @Query private var cartItems: [CartItem]

    private var isInCart: Bool {
        cartItems.contains { $0.id == product.id }
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
                        if isInCart {
                            if let item = cartItems.first(where: { $0.id == product.id }) {
                                modelContext.delete(item)
                            }
                        } else {
                            modelContext.insert(CartItem(product: product))
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

struct ZoomableImageView: View {
    let imageURL: URL
    @Environment(\.dismiss) private var dismiss

    @State private var zoomScale: CGFloat = 1.0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                    }
                }
                
                GeometryReader { geometry in
                    ScrollView(zoomScale > 1 ? [.horizontal, .vertical] : [], showsIndicators: false) {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(
                                    width: geometry.size.width * zoomScale
                                )
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        zoomScale = zoomScale == 1.0 ? 2.0 : 1.0
                                    }
                                }
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                    }
                }
            }
        }
    }
}



@Model
final class CartItem {
    var id: Int
    var title: String
    var price: Double
    var descriptionOfItem: String
    var category: String
    var imageURL: String
    var ratingRate: Double
    var ratingCount: Int

    init(id: Int, title: String, price: Double, description: String, category: String, imageURL: String, ratingRate: Double, ratingCount: Int) {
        self.id = id
        self.title = title
        self.price = price
        self.descriptionOfItem = description
        self.category = category
        self.imageURL = imageURL
        self.ratingRate = ratingRate
        self.ratingCount = ratingCount
    }
}

struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let imageURL: URL?
    let rating: ProductRating
}

struct ProductRating: Codable {
    let rate: Double
    let count: Int
}

extension Product {
    init(dto: ProductDTO) {
        self.id = dto.id
        self.title = dto.title
        self.price = dto.price
        self.description = dto.description
        self.category = dto.category
        self.imageURL = URL(string: dto.image)
        
        self.rating = ProductRating(rate: dto.rating.rate, count: dto.rating.count)
    }
}

extension Product {
    static var mockProducts: [Product] {
        (1...10).map {
            Product(id: $0, title: "Product \($0)", price: Double($0) * 10.0, description: "Description for product \($0)", category: "Category", imageURL: URL(string: "https://via.placeholder.com/150")!, rating: ProductRating(rate: 0.1, count: 5))
        }
    }
}

extension Product {
    init(cartItem: CartItem) {
        self.id = cartItem.id
        self.title = cartItem.title
        self.price = cartItem.price
        self.description = cartItem.descriptionOfItem
        self.category = cartItem.category
        self.imageURL = URL(string: cartItem.imageURL)
        self.rating = ProductRating(rate: cartItem.ratingRate, count: cartItem.ratingCount)
    }
}

extension CartItem {
    convenience init(product: Product) {
        self.init(
            id: product.id,
            title: product.title,
            price: product.price,
            description: product.description,
            category: product.category,
            imageURL: product.imageURL?.absoluteString ?? "",
            ratingRate: product.rating.rate,
            ratingCount: product.rating.count
        )
    }
}

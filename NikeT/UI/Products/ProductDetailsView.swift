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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = product.imageURL {
                    NavigationLink(destination: ZoomableImageView(imageURL: url)) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                    }
                }

                Text(product.title)
                    .font(.title)
                    .bold()

                Text(String(format: "$%.2f", product.price))
                    .font(.title2)

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

    @State private var scale: CGFloat = 1.0

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in scale = value }
                    )
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Zoom")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.black)
    }
}

//
//  ProductDetailsView.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 18. 4. 2025..
//

import SwiftUI

struct ProductDetailsView: View {
    let product: Product
    @State private var isZoomPresented = false
    
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
                        print("Add to Cart tapped for: \(product.title)")
                    }) {
                        Text("Add to Cart")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.blue)
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

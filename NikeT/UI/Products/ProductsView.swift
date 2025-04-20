//
//  ProductsView.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 18. 4. 2025..
//

import SwiftUI

struct ProductsView: View {
    
    @StateObject var viewModel: ProductsViewModelImpl
    @Environment(\.isLoading) private var isLoading: Binding<Bool>
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(viewModel.products) { product in
                    NavigationLink {
                        ProductDetailsView(product: product)
                    } label: {
                        ProductGridCell(product: product)
                    }
                }
            }
            .padding()
        }
        .onReceive(viewModel.$isLoading) {
            isLoading.wrappedValue = $0
        }
        .task {
            guard viewModel.isFetchNeeded else { return }
            await viewModel.fetchProducts()
        }
        .refreshable {
            await viewModel.reloadProducts()
        }
        .navigationTitle(Constants.navigationTitle)
        .alert(item: $viewModel.error) { error in
            Alert(
                title: Text(Constants.errorTitleText),
                message: Text(error.errorDescription ?? ""),
                dismissButton: .default(Text(Constants.okText)) {
                    viewModel.error = nil
                }
            )
        }
    }
}

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
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

extension ProductsView {
    struct Constants {
        static var navigationTitle: LocalizedStringKey { "Products" }
        static var errorTitleText: LocalizedStringKey { "Error" }
        static var okText: LocalizedStringKey { "Ok" }
    }
}

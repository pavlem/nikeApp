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
        
        List(viewModel.products) { product in
            
            NavigationLink {
                ProductDetailsView(product: product)
            } label: {
                ProductCell(product: product)
            }
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

extension ProductsView {
    struct Constants {
        static var navigationTitle: LocalizedStringKey { "Products" }
        static var errorTitleText: LocalizedStringKey { "Error" }
        static var okText: LocalizedStringKey { "Ok" }
    }
}

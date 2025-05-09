//
//  MainTabView.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 18. 4. 2025..
//

import SwiftUI

struct MainTabView: View {
    
    @State private var isLoading = false
    
//    MainTabView serves as app’s entry point into the main feature areas (ProductsView and CartView) and it's a place to inject dependencies and provide view models to child views.
    
    private let dependencyManager: DependencyManager

    init(dependencyManager: DependencyManager = .shared) {
        self.dependencyManager = dependencyManager
    }
    
    var body: some View {
        
        TabView {
        
            NavigationStack {
                ProductsView(viewModel: dependencyManager.makeProductsViewModel())
            }
            .tabItem {
                Label(Constants.productTabTitle, systemImage: Constants.productTabImage)
            }

            NavigationStack {
                CartView(viewModel: dependencyManager.makeCartViewModel())
            }
            .tabItem {
                Label(Constants.cartTabTitle, systemImage: Constants.cartTabImage)
            }
        }
        .environment(\.isLoading, $isLoading)
        .loadingView(isLoading: isLoading)
    }
}

extension MainTabView {
    struct Constants {
        static var productTabTitle: LocalizedStringKey { "Products" }
        static var productTabImage: String { "list.bullet" }
        static var cartTabTitle: LocalizedStringKey { "Cart" }
        static var cartTabImage: String { "cart" }
    }
}

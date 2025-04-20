//
//  MainTabView.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 18. 4. 2025..
//

import SwiftUI

private struct IsLoadingKey: EnvironmentKey {
  static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
  var isLoading: Binding<Bool> {
    get { self[IsLoadingKey.self] }
    set { self[IsLoadingKey.self] = newValue }
  }
}



struct MainTabView: View {
    
    @State private var isLoading = false
    
    var dependencyManager = DependencyManager.shared
    
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

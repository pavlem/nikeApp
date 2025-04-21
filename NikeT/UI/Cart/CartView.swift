//
//  CartView.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 18. 4. 2025..
//

import SwiftUI
import SwiftData

struct CartView: View {
    
    @State var viewModel: CartViewModelImpl
    
//   cartItems and modelContext are SwiftUl property wrappers, and they only work inside SwiftUl Views (i.e., structs conforming to View).
//    They rely on SwiftUl's internal environment and view lifecycle to function properly.
    
    @Query var cartItems: [CartItem]
    @Environment(\.modelContext) private var modelContext
    
    // Global Environment property loading state.
    @Environment(\.isLoading) private var isLoading: Binding<Bool>

    private let dependencyManager: DependencyManager = DependencyManager.shared
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            
            ZStack {
                
                List {
                    ForEach(cartItems) { item in
                        
                        NavigationLink {
                            let vm = dependencyManager.makeProductDetailsViewModel(product: Product(cartItem: item))
                            
                            ProductDetailsView(viewModel: vm)
                        } label: {
                            CartItemCell(item: item)
                        }
                        .swipeActions(edge: .trailing) {
                            removeAction(for: item)
                        }
                    }
                }
                
                if cartItems.isEmpty {
                    Text(Constants.emptyCartTitle)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                }
            }
            
            HStack {
                
                VStack(alignment: .leading) {
                    
                    Text(viewModel.getTotalNumberOfItemsText(cartItems: cartItems))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(viewModel.getTotalValueOfItemsText(cartItems: cartItems))
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }

                CheckoutButton(
                    title: Constants.checkOutText,
                    isDisabled: cartItems.isEmpty,
                    action: {
                        viewModel.checkoutAlert()
                    }
                )
            }
            .padding()
        }
        .onReceive(viewModel.$isLoading) {
            isLoading.wrappedValue = $0
        }
        .navigationTitle(Constants.navigationTitle)
        .alert(item: $viewModel.alert) { alert in
            
            switch alert {
            case .checkoutSuccess:
                Alert(
                    title: Text(Constants.checkoutSuccessTitle),
                    message: Text(Constants.checkoutSuccessMsg),
                    dismissButton: .default(Text(Constants.okText)) {
                        viewModel.alert = nil
                    }
                )
                
            case .error(let errTxt):
                
                Alert(
                    title: Text(Constants.errorTitleText),
                    message: Text(errTxt),
                    dismissButton: .default(Text(Constants.okText)) {
                        viewModel.alert = nil
                    }
                )

            case .checkoutConfirmation:
                Alert(
                    title: Text(Constants.checkoutTitleText),
                    message: Text(Constants.checkoutInfoText),
                    primaryButton: .destructive(Text(Constants.okText)) {
                        Task {
                            await viewModel.checkout(cartItems: cartItems, context: modelContext)
                        }
                    },
                    secondaryButton: .cancel()
                )

            }
        }
    }
    
    private func removeAction(for item: CartItem) -> some View {
        Button(role: .destructive) {
            viewModel.remove(item: item, from: modelContext)
        } label: {
            Label(Constants.removeText, systemImage: Constants.removeImageName)
        }
    }
}

extension CartView {
    struct Constants {
        static var removeText: LocalizedStringKey { "Remove" }
        static var removeImageName: String { "trash" }
        static var checkOutText: String { "Checkout" }
        static var navigationTitle: String { "Cart" }
        static var errorTitleText: LocalizedStringKey { "Error" }
        static var okText: LocalizedStringKey { "Ok" }
        
        static var checkoutSuccessTitle: LocalizedStringKey { "Success" }
        static var checkoutSuccessMsg: LocalizedStringKey { "All the items have been checked out!" }
        static var emptyCartTitle: LocalizedStringKey { "Please add some items from the product catalog" }
        
        static var checkoutTitleText: LocalizedStringKey { "Checkout" }
        static var checkoutInfoText: LocalizedStringKey { "You are about to checkout your cart, are you sure?" }

    }
}

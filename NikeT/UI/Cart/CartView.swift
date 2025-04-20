//
//  CartView.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 18. 4. 2025..
//

import SwiftUI
import SwiftData

protocol CartViewModel: Observable {
    
    func remove(item: CartItem, from context: ModelContext)
    func checkout(cartItems: [CartItem])
}

class CartViewModelImpl: ObservableObject {
    
    func remove(item: CartItem, from context: ModelContext) {
        context.delete(item)
    }
    
    func checkout(cartItems: [CartItem]) {
        print("🛒 Checkout items:")
        for item in cartItems {
            print("- \(item.title) - $\(item.price)")
        }
    }
}

struct CartView: View {
    @State private var viewModel = CartViewModelImpl()
    @Query var cartItems: [CartItem]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        
        NavigationStack {
            
            
            VStack(spacing: 0) {
                List {
                    
                    ForEach(cartItems) { item in
                        
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            Text(String(format: "$%.2f", item.price))
                                .font(.subheadline)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.remove(item: item, from: modelContext)
                            } label: {
                                Label(Constants.removeText, systemImage: Constants.removeImageName)
                            }
                        }
                    }
                }
                
                
                CheckoutButton(
                    title: Constants.checkOutText,
                    isDisabled: cartItems.isEmpty,
                    action: { viewModel.checkout(cartItems: cartItems) }
                )
                .padding()
            }
            .navigationTitle(Constants.navigationTitle)
        }
    }
}

extension CartView {
    struct Constants {
        static var removeText: LocalizedStringKey { "Remove" }
        static var removeImageName: String { "trash" }
        static var checkOutText: String { "Checkout" }
        static var navigationTitle: String { "Cart" }
    }
}

struct CheckoutButton: View {
    
    let title: String
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(isDisabled ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .disabled(isDisabled)
    }
}

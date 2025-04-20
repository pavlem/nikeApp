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
            .navigationTitle(Constants.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        viewModel.checkout(cartItems: cartItems)
                    }) {
                        Text(Constants.checkOutText)
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(cartItems.isEmpty ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(cartItems.isEmpty)
                }
            }
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

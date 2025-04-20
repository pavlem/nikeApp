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
                        CartItemCell(item: item)
                            .swipeActions(edge: .trailing) {
                                removeAction(for: item)
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
    
    private func removeAction(for item: CartItem) -> some View {
        Button(role: .destructive) {
            viewModel.remove(item: item, from: modelContext)
        } label: {
            Label(Constants.removeText, systemImage: Constants.removeImageName)
        }
    }
}

private struct CartItemCell: View {
    
    let item: CartItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: item.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(String(format: "$%.2f", item.price))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
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

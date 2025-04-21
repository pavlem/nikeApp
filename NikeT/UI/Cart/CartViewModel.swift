//
//  CartViewModel.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import SwiftUI
import SwiftData

enum CheckoutAlert: Identifiable {
    case checkoutSuccess
    case checkoutConfirmation
    case error(String) // Includes an error message
    
    var id: Int {
        switch self {
        case .checkoutSuccess:
            return 1
        case .error:
            return 2
        case .checkoutConfirmation:
            return 3
        }
    }
}

enum CheckoutError: LocalizedError {
    case testError
    case networkError(Error)
    case checkoutFailed
    
    var errorDescription: String? {
        switch self {
        case .testError:
            return "This is a test error."
        case .networkError(let err):
            return err.localizedDescription
        case .checkoutFailed:
            return "Checkout failed. Please try again later."
        }
    }
}

protocol CartViewModel: Observable {
    func remove(item: CartItem, from context: ModelContext)
    func checkout(cartItems: [CartItem], context: ModelContext) async
    func getTotalNumberOfItemsText(cartItems: [CartItem]) -> String
    func getTotalValueOfItemsText(cartItems: [CartItem]) -> String
}

class CartViewModelImpl: CartViewModel, ObservableObject {
    
    @Published var isLoading = false
    @Published var alert: CheckoutAlert?
    
    private let useCase: CartUseCase
    
    init(useCase: CartUseCase) {
        self.useCase = useCase
    }
    
    func getTotalNumberOfItemsText(cartItems: [CartItem]) -> String {
        return "Items in cart" + ": " + "\(cartItems.count)"
    }
    
    func remove(item: CartItem, from context: ModelContext) {
        useCase.remove(item: item, from: context)
    }
    
    func getTotalValueOfItemsText(cartItems: [CartItem]) -> String {
        String(format: "Total: $%.2f", cartItems.reduce(0) { $0 + $1.price })
    }
    
    func checkoutAlert() {
        alert = .checkoutConfirmation
    }
    
    @MainActor
    func checkout(cartItems: [CartItem], context: ModelContext) async {
        
        isLoading = true
        
        do {
            
            // Network call (simulated long polling)
            try await useCase.checkout(cartItems: cartItems)
           
            // Delete all items in Cart from DB
            for item in cartItems {
                context.delete(item)
            }
            
            // Inform the user via Alert
            isLoading = false

            alert = .checkoutSuccess

        } catch {
            isLoading = false

            let err = CheckoutError.checkoutFailed
            alert = .error(err.errorDescription ?? "-")
        }
    }
}

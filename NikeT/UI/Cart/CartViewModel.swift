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
    case error(String) // Includes an error message
    
    var id: Int {
        switch self {
        case .checkoutSuccess:
            return 1
        case .error:
            return 2
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
    func checkout(cartItems: [CartItem])
}

class CartViewModelImpl: ObservableObject {
    
    @Published var isLoading = false
    @Published var alert: CheckoutAlert?

    private let cartUseCase: CartUseCase
    
    init(cartUseCase: CartUseCase) {
        self.cartUseCase = cartUseCase
    }
    
    func remove(item: CartItem, from context: ModelContext) {
        cartUseCase.remove(item: item, from: context)
    }
    
    @MainActor
    func checkout(cartItems: [CartItem], context: ModelContext) async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            try await cartUseCase.checkout(cartItems: cartItems)
            for item in cartItems {
                context.delete(item)
            }
            self.alert = .checkoutSuccess

        } catch {
            let err = CheckoutError.checkoutFailed
            self.alert = .error(err.errorDescription ?? "-")
        }
    }
}

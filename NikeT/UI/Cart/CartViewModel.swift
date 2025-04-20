//
//  CartViewModel.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import SwiftUI
import SwiftData

protocol CheckoutAPI {
    func checkout(cartItems: [CartItem]) async throws -> VoidDTO
}

class CheckoutAPIImpl: API, CheckoutAPI {
   
    func checkout(cartItems: [CartItem]) async throws -> VoidDTO {
        
        
        // TODO: convert cartItems to DTO if needed
//        let requestBuilder = RequestBuilder(
//            route: .checkout,
//            method: .post,
//            body: cartItems
//        )

//        do {
            
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return VoidDTO()
        
//            throw APIError.networkError
        
            
//            let urlRequest = try requestBuilder.build()
//            Task {
//                let _: EmptyResponse = try await session.request(urlRequest)
//                print("✅ Checkout successful")
//            }
            
//        } catch {
//            print("❌ Checkout failed:", error)
//        }
    }
}

protocol CartUseCase {
    func checkout(cartItems: [CartItem]) async throws
}

class CartUseCaseImpl: CartUseCase {
    private let checkoutAPI: CheckoutAPI

    init(checkoutAPI: CheckoutAPI) {
        self.checkoutAPI = checkoutAPI
    }

    func checkout(cartItems: [CartItem]) async throws {
        let _ = try await checkoutAPI.checkout(cartItems: cartItems)
    }
}









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
    
    var errorDescription: String? {
        switch self {
        case .testError:
            return "This is a test error."
        case .networkError(let err):
            return err.localizedDescription
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
    
//    @Published var error: CheckoutError?

    init(cartUseCase: CartUseCase) {
        self.cartUseCase = cartUseCase
    }
    
    func remove(item: CartItem, from context: ModelContext) {
        context.delete(item)
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
            let err = CheckoutError.networkError(error)
            self.alert = .error(err.errorDescription ?? "-")
        }
    }
}

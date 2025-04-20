//
//  CartViewModel.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import SwiftUI
import SwiftData

enum APIError: Error {
    case networkError
    case timeout
    case invalidURL
}

protocol CheckoutAPI {
    func checkout(cartItems: [CartItem]) async throws -> VoidDTO
}

class CheckoutAPIImpl: API, CheckoutAPI {
   
    func checkout(cartItems: [CartItem]) async throws -> VoidDTO {
        
        let pollingURL = URL(string: "https://httpbin.org/delay/10")!
        let maxWaitTime: TimeInterval = 4 // 60
        let pollInterval: TimeInterval = 1 //3

        let startTime = Date()

        while Date().timeIntervalSince(startTime) < maxWaitTime {
            print("Polling...")
            let (data, response) = try await URLSession.shared.data(from: pollingURL)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Simulate detecting success condition in response (always true in this fake API)
                return VoidDTO()
            }

            try await Task.sleep(nanoseconds: UInt64(pollInterval * 1_000_000_000))
        }

        throw APIError.timeout
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

//
//  CartUseCase.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import Foundation
import SwiftData

protocol CartUseCase {
    func checkout(cartItems: [CartItem]) async throws
    func remove(item: CartItem, from context: ModelContext)
}

class CartUseCaseImpl: CartUseCase {
    
    private let api: CheckoutAPI

    func checkout(cartItems: [CartItem]) async throws {
        let _ = try await api.checkout(cartItems: cartItems)
    }
    
    func remove(item: CartItem, from context: ModelContext) {
        context.delete(item)
    }

    init(api: CheckoutAPI) {
        self.api = api
    }
}

//
//  ProductDetailsUseCase.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import Foundation
import SwiftData

protocol ProductDetailsUseCase {
    var product: Product { get set }
    func remove(item: CartItem, from context: ModelContext)
    func insert(cartItem: CartItem, to context: ModelContext)
}

class ProductDetailsUseCaseImpl: ProductDetailsUseCase {
    var product: Product
    
    func remove(item: CartItem, from context: ModelContext) {
        context.delete(item)
    }
    
    func insert(cartItem: CartItem, to context: ModelContext) {
        context.insert(cartItem)
    }
    
    init(product: Product) {
        self.product = product
    }
}

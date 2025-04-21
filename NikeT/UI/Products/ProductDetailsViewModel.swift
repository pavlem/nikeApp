//
//  ProductDetailsViewModel.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import SwiftUI
import SwiftData

protocol ProductDetailsViewModel: ObservableObject {
    var isZoomPresented: Bool { get set }
    var categoryText: String { get }
    var descriptionText: String { get }
    var imageURL: URL? { get }
    var priceText: String { get }
    var productTitle: String { get }
    var ratingCountText: String { get }
    var ratingStars: [Bool] { get }
    var product: Product { get }
    var rate: Double { get }
    
    func existingCartItem(cartItems: [CartItem]) -> CartItem?
    func isInCart(cartItems: [CartItem]) -> Bool
    func textForCartButton(cartItems: [CartItem]) -> Bool
    func buttonTitle(cartItems: [CartItem]) -> String
    func buttonColor(cartItems: [CartItem]) -> Color
    func imageName(forIndex index: Int) -> String
    
    func remove(item: CartItem, from context: ModelContext)
    func insert(cartItem: CartItem, to context: ModelContext)
    
}

class ProductDetailsViewModelImpl: ProductDetailsViewModel, ObservableObject {
    
    @Published var isZoomPresented = false
    var categoryText: String { "\(Constants.categoryText)" + ": " + useCase.product.category }
    var descriptionText: String { useCase.product.description }
    var imageURL: URL? { useCase.product.imageURL }
    var priceText: String { String(format: "$%.2f", useCase.product.price) }
    var productTitle: String { useCase.product.title }
    var ratingCountText: String { "(\(useCase.product.rating.count))" }
    var ratingStars: [Bool] { (1...5).map { $0 <= Int(round(useCase.product.rating.rate)) }}
    var product: Product { useCase.product }
    
    var rate: Double { useCase.product.rating.rate }
    
    
    private var useCase: ProductDetailsUseCase
    
    func remove(item: CartItem, from context: ModelContext) {
        useCase.remove(item: item, from: context)
    }
    
    func insert(cartItem: CartItem, to context: ModelContext) {
        useCase.insert(cartItem: cartItem, to: context)
    }
    
    func existingCartItem(cartItems: [CartItem]) -> CartItem? {
        return cartItems.first(where: { $0.id == useCase.product.id })
    }
    
    func isInCart(cartItems: [CartItem]) -> Bool {
        cartItems.contains { $0.id == useCase.product.id }
    }
    
    func textForCartButton(cartItems: [CartItem]) -> Bool {
        cartItems.contains { $0.id == useCase.product.id }
    }
    
    func buttonTitle(cartItems: [CartItem]) -> String {
        cartItems.contains { $0.id == useCase.product.id } ? Constants.removeFromCart : Constants.addToCart
    }
    
    func buttonColor(cartItems: [CartItem]) -> Color {
        isInCart(cartItems: cartItems) ? Color.red : Color.blue
    }
    
    func imageName(forIndex index: Int) -> String {
        index <= Int(round(rate)) ? "star.fill" : "star"
    }
    
    init(useCase: ProductDetailsUseCase) {
        self.useCase = useCase
    }
}

extension ProductDetailsViewModelImpl {
    struct Constants {
        static var categoryText: String { "Category" }
        static var removeFromCart: String { "Remove from Cart" }
        static var addToCart: String { "Add to Cart" }
    }
}

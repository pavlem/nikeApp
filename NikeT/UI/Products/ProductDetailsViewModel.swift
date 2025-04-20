//
//  ProductDetailsViewModel.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import SwiftUI

protocol ProductDetailsUseCase {
    
}

class ProductDetailsUseCaseImpl: ProductDetailsUseCase {
    
}





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
    
    func existingCartItem(cartItems: [CartItem]) -> CartItem?
    func isInCart(cartItems: [CartItem]) -> Bool
    func textForCartButton(cartItems: [CartItem]) -> Bool
    func buttonTitle(cartItems: [CartItem]) -> String
    func buttonColor(cartItems: [CartItem]) -> Color
    func imageName(forIndex index: Int) -> String
}

class ProductDetailsViewModelImpl: ProductDetailsViewModel, ObservableObject {
    
    @Published var isZoomPresented = false
    
    var categoryText: String { "\(Constants.categoryText)" + ": " + product.category }
    var descriptionText: String { product.description }
    var imageURL: URL? { product.imageURL }
    var priceText: String { String(format: "$%.2f", product.price) }
    var productTitle: String { product.title }
    var ratingCountText: String { "(\(product.rating.count))" }
    var ratingStars: [Bool] { (1...5).map { $0 <= Int(round(product.rating.rate)) }}
    
    private(set) var product: Product
    
    func existingCartItem(cartItems: [CartItem]) -> CartItem? {
        return cartItems.first(where: { $0.id == product.id })
    }
    
    func isInCart(cartItems: [CartItem]) -> Bool {
        cartItems.contains { $0.id == product.id }
    }
    
    func textForCartButton(cartItems: [CartItem]) -> Bool {
        cartItems.contains { $0.id == product.id }
    }
    
    func buttonTitle(cartItems: [CartItem]) -> String {
        cartItems.contains { $0.id == product.id } ? "Remove from Cart" : "Add to Cart"
    }
    
    func buttonColor(cartItems: [CartItem]) -> Color {
        isInCart(cartItems: cartItems) ? Color.red : Color.blue
    }
    
    func imageName(forIndex index: Int) -> String {
        index <= Int(round(product.rating.rate)) ? "star.fill" : "star"
    }
    
    init(product: Product) {
        self.product = product
    }
}

extension ProductDetailsViewModelImpl {
    struct Constants {
        static var categoryText: String { "Category" }
    }
}

//
//  Product.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 18. 4. 2025..
//

import Foundation
import SwiftData

struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let imageURL: URL?
    let rating: ProductRating
}

struct ProductRating: Codable {
    let rate: Double
    let count: Int
}

extension Product {
    init(dto: ProductDTO) {
        self.id = dto.id
        self.title = dto.title
        self.price = dto.price
        self.description = dto.description
        self.category = dto.category
        self.imageURL = URL(string: dto.image)
        
        self.rating = ProductRating(rate: dto.rating.rate, count: dto.rating.count)
    }
}

extension Product {
    static var mockProducts: [Product] {
        (1...10).map {
            Product(id: $0, title: "Product \($0)", price: Double($0) * 10.0, description: "Description for product \($0)", category: "Category", imageURL: URL(string: "https://via.placeholder.com/150")!, rating: ProductRating(rate: 0.1, count: 5))
        }
    }
}

extension Product {
    init(cartItem: CartItem) {
        self.id = cartItem.id
        self.title = cartItem.title
        self.price = cartItem.price
        self.description = cartItem.descriptionOfItem
        self.category = cartItem.category
        self.imageURL = URL(string: cartItem.imageURL)
        self.rating = ProductRating(rate: cartItem.ratingRate, count: cartItem.ratingCount)
    }
}

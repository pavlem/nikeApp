//
//  CartItem.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import SwiftData
import Foundation

@Model
class CartItem {
    var id: Int
    var title: String
    var price: Double
    var descriptionOfItem: String
    var category: String
    var imageURL: String
    var ratingRate: Double
    var ratingCount: Int

    init(id: Int, title: String, price: Double, description: String, category: String, imageURL: String, ratingRate: Double, ratingCount: Int) {
        self.id = id
        self.title = title
        self.price = price
        self.descriptionOfItem = description
        self.category = category
        self.imageURL = imageURL
        self.ratingRate = ratingRate
        self.ratingCount = ratingCount
    }
}



extension CartItem {
    convenience init(product: Product) {
        self.init(
            id: product.id,
            title: product.title,
            price: product.price,
            description: product.description,
            category: product.category,
            imageURL: product.imageURL?.absoluteString ?? "",
            ratingRate: product.rating.rate,
            ratingCount: product.rating.count
        )
    }
}

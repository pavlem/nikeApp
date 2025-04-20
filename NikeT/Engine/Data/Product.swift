//
//  Product.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 18. 4. 2025..
//

import Foundation

struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let imageURL: URL?
}

extension Product {
    init(dto: ProductDTO) {
        self.id = dto.id
        self.title = dto.title
        self.price = dto.price
        self.description = dto.description
        self.category = dto.category
        self.imageURL = URL(string: dto.image)
    }
}
extension Product {
    static var mockProducts: [Product] {
        (1...10).map {
            Product(id: $0, title: "Product \($0)", price: Double($0) * 10.0, description: "Description for product \($0)", category: "Category", imageURL: URL(string: "https://via.placeholder.com/150")!)
        }
    }
}

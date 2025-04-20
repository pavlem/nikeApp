//
//  ProductDTO.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 19. 4. 2025..
//

import Foundation

/// Represents product rating information.
struct ProductRatingDTO: Decodable {
    let rate: Double
    let count: Int
}

/// Represents a product fetched from the API.
struct ProductDTO: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: ProductRatingDTO
}

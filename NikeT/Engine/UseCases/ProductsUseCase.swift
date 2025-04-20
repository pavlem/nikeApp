//
//  ProductDTO.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 19. 4. 2025..
//

import Foundation

/// Defines the contract for fetching products.
protocol ProductsUseCase {
    
    /// Fetches all products.
    /// - Returns: An array of `Product`.
    /// - Throws: An error if the fetch fails.
    func fetchProducts() async throws -> [Product]
}

class ProductsUseCaseImpl: ProductsUseCase {
    
    func fetchProducts() async throws -> [Product] {
        let productsDTOs = try await api.fetchProducts()
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 s delay
        return productsDTOs.map { Product(dto: $0) }
    }
    
    private var api: ProductsAPI

    init(api: ProductsAPI) {
        self.api = api
    }
}

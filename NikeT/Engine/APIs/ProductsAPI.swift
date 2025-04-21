//
//  ProductsAPI.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import Foundation

protocol ProductsAPI {
    func fetchProducts() async throws -> [ProductDTO]
}

class ProductsMockAPIImpl: API, ProductsAPI {
    func fetchProducts() async throws -> [ProductDTO] {
        guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
            throw NSError(domain: "ProductsAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock products.json not found"])
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([ProductDTO].self, from: data)
    }
}

class ProductsAPIImpl: API, ProductsAPI {
    
    func fetchProducts() async throws -> [ProductDTO] {
        let requestBuilder = RequestBuilder(
            route: .products,
            method: .get
        )
        
        let urlRequest = try requestBuilder.build()
        
        return try await session.request(urlRequest)
    }
}

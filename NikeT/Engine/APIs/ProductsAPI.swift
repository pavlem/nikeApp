//
//  ProductsAPI.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import Foundation

protocol CheckOutAPI {
    func checkOut() async throws -> VoidDTO
}

protocol ProductsAPI {
    func fetchProducts() async throws -> [ProductDTO]
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

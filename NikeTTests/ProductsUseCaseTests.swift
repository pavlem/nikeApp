//
//  ProductsUseCaseTests.swift
//  NikeTTests
//
//  Created by Pavle Mijatovic on 21. 4. 2025..
//

import XCTest
@testable import NikeT

class ProductsUseCaseTests: XCTestCase {

    class MockProductsAPI: ProductsAPI {
        
        var wasCalled = false

        func fetchProducts() async throws -> [ProductDTO] {
            wasCalled = true
            return [
                ProductDTO(
                    id: 1,
                    title: "Product 123",
                    price: 29.99,
                    description: "Description 123",
                    category: "Category 123",
                    image: "https://somesite.com/image.jpg",
                    rating: ProductRatingDTO(rate: 4.7, count: 200)
                )
            ]
        }
    }

    func testFetchProducts_returnsMappedProducts() async throws {
        // Given
        let mockAPI = MockProductsAPI()
        let sut = ProductsUseCaseImpl(api: mockAPI)

        // When
        let products = try await sut.fetchProducts()

        // Then
        XCTAssertTrue(mockAPI.wasCalled)
        XCTAssertEqual(products.count, 1)
        XCTAssertEqual(products.first?.id, 1)
        XCTAssertEqual(products.first?.title, "Product 123")
        XCTAssertEqual(products.first?.price, 29.99)
    }
}

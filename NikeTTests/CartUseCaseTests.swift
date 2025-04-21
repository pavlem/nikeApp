//
//  CartUseCaseTests.swift
//  NikeTTests
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import XCTest
import SwiftData

@testable import NikeT

final class CartUseCaseTests: XCTestCase {

    // MARK: - Mocks

    class MockCheckoutAPI: CheckoutAPI {
        var didCallCheckout = false
        var passedCartItems: [CartItem] = []

        func checkout(cartItems: [CartItem]) async throws -> VoidDTO {
            didCallCheckout = true
            passedCartItems = cartItems
            return VoidDTO()
        }
    }

    // MARK: - Properties

    var sut: CartUseCaseImpl!
    var mockAPI: MockCheckoutAPI!

    override func setUp() {
        super.setUp()
        mockAPI = MockCheckoutAPI()
        sut = CartUseCaseImpl(api: mockAPI)
    }

    func testCheckout_callsAPIWithCartItems() async throws {
        // Given
        let cartItems = [CartItem(id: 1, title: "Test", price: 10.0, description: "", category: "", imageURL: "", ratingRate: 0, ratingCount: 0)]

        // When
        try await sut.checkout(cartItems: cartItems)

        // Then
        XCTAssertTrue(mockAPI.didCallCheckout)
        XCTAssertEqual(mockAPI.passedCartItems.map(\.id), cartItems.map(\.id))
    }

    func testRemove_deletesItemFromModelContext() throws {
        
        // Given
        let container = try ModelContainer(for: CartItem.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = ModelContext(container)
        let item = CartItem(id: 1, title: "Test", price: 10.0, description: "", category: "", imageURL: "", ratingRate: 0, ratingCount: 0)
        context.insert(item)

        // When
        sut.remove(item: item, from: context)

        // Then
        let descriptor = FetchDescriptor<CartItem>(predicate: #Predicate<CartItem> { $0.id == 1 })
        let results = try context.fetch(descriptor)
        XCTAssertTrue(results.isEmpty)
    }
}

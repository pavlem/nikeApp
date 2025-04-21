import XCTest
@testable import NikeT

class ProductsViewModelTests: XCTestCase {

    class MockProductsUseCase: ProductsUseCase {
        var wasCalled = false
        var mockProducts: [Product] = []

        func fetchProducts() async throws -> [Product] {
            wasCalled = true
            return mockProducts
        }
    }

    func testFetchProducts_populatesProductsAndSetsLoadingState() async throws {
        // Given
        let mockUseCase = MockProductsUseCase()
        mockUseCase.mockProducts = [
            Product(id: 1, title: "Mock", price: 9.99, description: "desc", category: "cat", imageURL: nil, rating: ProductRating(rate: 4.2, count: 8))
        ]
        let viewModel = ProductsViewModelImpl(useCase: mockUseCase)

        // Initially
        XCTAssertTrue(viewModel.products.isEmpty)
        XCTAssertFalse(viewModel.isLoading)

        // When
        await viewModel.fetchProducts()

        // Then
        XCTAssertTrue(mockUseCase.wasCalled)
        XCTAssertEqual(viewModel.products.count, 1)
        XCTAssertEqual(viewModel.products.first?.id, 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
}

//
//  ProductsViewModel.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import Foundation

enum ProductsError: LocalizedError, Identifiable {
    case testError
    case networkError(Error)
    
    var id: String { errorDescription ?? UUID().uuidString }
    
    var errorDescription: String? {
        switch self {
        case .testError:
            return "This is a test error."
        case .networkError(let err):
            return err.localizedDescription
        }
    }
}

protocol ProductsViewModel: ObservableObject {
    var products: [Product] { get set }
    var isLoading: Bool { get set }
    var error: ProductsError? { get set }
    var isFetchNeeded: Bool { get }
    
    func fetchProducts() async
    func reloadProducts() async
}

class ProductsViewModelImpl: ProductsViewModel {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var error: ProductsError?
    
    var isFetchNeeded: Bool { products.isEmpty }
    
    private let useCase: ProductsUseCase
    
    init(useCase: ProductsUseCase) {
        self.useCase = useCase
    }
    
    @MainActor
    func fetchProducts() async {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            products = try await useCase.fetchProducts()
        } catch {
            self.error = .networkError(error)
        }
    }
    
    @MainActor
    func reloadProducts() async {
        await fetchProducts()
    }
}

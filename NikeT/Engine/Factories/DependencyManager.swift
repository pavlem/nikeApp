//
//  ProductDTO.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 19. 4. 2025..
//

import Foundation

class DependencyManager {
    static let shared = DependencyManager()
    
    private var commsSession: CommsSession?
}

extension DependencyManager {
    
    // MARK: - Services
    func makeCommsSession() -> CommsSession {
        if commsSession == nil {
            commsSession = CommsSessionImpl()
        }
        return commsSession!
    }
    
    // MARK: - Use Cases
    func makeProductsUseCase() -> ProductsUseCase {
        let session = makeCommsSession()
        let productsAPI = ProductsAPIImpl(session: session)
        //        let productsAPI = ProductsMockAPIImpl(session: CommsSessionImpl()) // to mock products response
        return ProductsUseCaseImpl(api: productsAPI)
    }
    
    func makeProductDetailsUseCase(for product: Product) -> ProductDetailsUseCase {
        let useCase = ProductDetailsUseCaseImpl(product: product)
        return useCase
    }
    
    func makeCartUseCase() -> CartUseCase {
        let session = makeCommsSession()
        let checkoutAPI = CheckoutAPIImpl(session: session)
        let useCase = CartUseCaseImpl(api: checkoutAPI)
        return useCase
    }
    
    // MARK: - View Models
    func makeProductsViewModel() -> ProductsViewModelImpl {
        return ProductsViewModelImpl(useCase: makeProductsUseCase())
    }
    
    func makeProductDetailsViewModel(product: Product) -> ProductDetailsViewModelImpl {
        let useCase = makeProductDetailsUseCase(for: product)
        return ProductDetailsViewModelImpl(useCase: useCase)
    }
    
    func makeCartViewModel() -> CartViewModelImpl {
        return CartViewModelImpl(useCase: makeCartUseCase())
    }
}

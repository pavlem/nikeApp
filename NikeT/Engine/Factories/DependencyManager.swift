//
//  ProductDTO.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 19. 4. 2025..
//

import Foundation

class DependencyManager {
    static let shared = DependencyManager()
}

extension DependencyManager {
    
    func makeProductsViewModel() -> ProductsViewModelImpl {
        let session = CommsSessionImpl()
        
        let productsAPI = ProductsAPIImpl(session: session)
//        let productsAPI = ProductsMockAPIImpl(session: CommsSessionImpl()) // to mock products response
        let useCase = ProductsUseCaseImpl(api: productsAPI)
        return ProductsViewModelImpl(useCase: useCase)
    }
    
    func makeProductDetailsViewModel(product: Product) -> ProductDetailsViewModelImpl {
        
        ProductDetailsViewModelImpl(product: product)
    }
    
    func makeCartViewModel() -> CartViewModelImpl {
        let session = CommsSessionImpl()

        return CartViewModelImpl(cartUseCase: CartUseCaseImpl(checkoutAPI: CheckoutAPIImpl(session: session)))
    }
    
}

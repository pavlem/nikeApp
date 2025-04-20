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
//        let productsAPI = ProductsAPIImpl(session: CommsSessionImpl())
        let productsAPI = ProductsMockAPIImpl(session: CommsSessionImpl()) // to mock products response 
        let useCase = ProductsUseCaseImpl(api: productsAPI)
        return ProductsViewModelImpl(useCase: useCase)
    }
}

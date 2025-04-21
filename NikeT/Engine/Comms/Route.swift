//
//  ProductDTO.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 19. 4. 2025..
//

import Foundation

enum Route {
    
    case products
    
    var url: URL {
        switch self {
        case .products:
            return Route.buildURL(baseURL: Route.apiBaseUrl, path: "/products")
        }
    }
            
    private static func buildURL(baseURL: String, path: String) -> URL {
        var components = URLComponents(string: baseURL)!
        
        // Append the additional path to the base URL's path
        components.path += path
        guard let url = components.url else {
            fatalError("Invalid URL components")
        }
        return url
    }
    
    private static var apiBaseUrl: String { "https://fakestoreapi.com" }
}

//
//  API.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 19. 4. 2025..
//

import Foundation

enum APIError: Error {
    case invalidURL
}

enum Method {
    case get
    case post(Encodable)
    case put(Encodable)
    case delete
    
    var httpMethod: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        }
    }
}


class RequestBuilder {
    let route: Route
    let method: Method
    let params: [String: Any]
    let headers: [String: String]
    
    init(
        route: Route,
        method: Method,
        params: [String: Any] = [:],
        headers: [String: String] = [:]) {
            self.route = route
            self.method = method
            self.params = params
            self.headers = headers

        }
    
    func build(isContentTypeJson: Bool = true) throws -> URLRequest {
        var urlComponents = URLComponents(url: route.url, resolvingAgainstBaseURL: false)!
        
        // Add query parameters if needed
//        if !params.isEmpty {
//            urlComponents.queryItems = params.map {
//                URLQueryItem(name: $0.key, value: "\($0.value)") // Convert Any to String
//            }
//        }
        
//        if !params.isEmpty {
//            urlComponents.queryItems = params.flatMap { key, value -> [URLQueryItem] in
//                if let arrayValue = value as? [Int] {
//                    return [URLQueryItem(name: key, value: arrayValue.map(String.init).joined(separator: ","))]
//                }
//                return [URLQueryItem(name: key, value: "\(value)")]
//            }
//        }
        
        
        if !params.isEmpty {
            urlComponents.queryItems = params.flatMap { key, value -> [URLQueryItem] in
                if let arrayValue = value as? [Int] {
                    return [URLQueryItem(name: key, value: arrayValue.map(String.init).joined(separator: ","))]
                } else {
                    return [URLQueryItem(name: key, value: "\(value)")]
                }
            }
        }
        
        
        // Validate URL
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        // Create URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.httpMethod

        // Add additional headers if needed
        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        
        // Encode body if necessary
        switch method {
        case .post(let body), .put(let body):
            let jsonData = try JSONEncoder().encode(body)
            urlRequest.httpBody = jsonData
        default:
            break
        }
        
        return urlRequest
    }
}






class API {
    let session: CommsSession

    init(session: CommsSession) {
        self.session = session
    }
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
    
//    func getProducts() async throws -> [ProductDTO] {
//        let url = URL(string: "https://fakestoreapi.com/products")!
//        do {
//            let (data, response) = try await URLSession.shared.data(from: url)
//            guard let http = response as? HTTPURLResponse,
//                  (200..<300).contains(http.statusCode) else {
//                throw URLError(.badServerResponse)
//            }
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            return try decoder.decode([ProductDTO].self, from: data)
//        } catch {
//            print("⚠️ Fetch error:", error)
//            throw error
//        }
//    }
    
//    func fetchProducts() async throws -> [ProductDTO] {
//        let url = URL(string: "https://fakestoreapi.com/products")!
//        do {
//            let (data, response) = try await URLSession.shared.data(from: url)
//            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
//                throw URLError(.badServerResponse)
//            }
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            return try decoder.decode([ProductDTO].self, from: data)
//        } catch URLError.networkConnectionLost {
//            // optionally retry once
//            return try await fetchProducts()
//        }
//    }
}

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


protocol CommsSession {
    func request<T: Decodable>(_ urlRequest: URLRequest) async throws -> T
}

class CommsSessionImpl: CommsSession {
    
    func request<T: Decodable>(_ urlRequest: URLRequest) async throws -> T {
        DebugPrint.print(urlRequest, isHeaderPrinted: true, isBodyPrinted: true)
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            DebugPrint.print(response, andData: data)
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error {
            print(error)
            throw error
        }
    }
}

//
//  ProductDTO.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 19. 4. 2025..
//

import Foundation

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

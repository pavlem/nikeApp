//
//  CommsSession.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import Foundation

enum APIError: Error {
    case invalidURL
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
            throw error
        }
    }
}

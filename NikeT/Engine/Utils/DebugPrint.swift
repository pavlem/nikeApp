//
//  ProductDTO.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 19. 4. 2025..
//

import Foundation

class DebugPrint {
    
    static func print(_ request: URLRequest, isHeaderPrinted: Bool = false, isBodyPrinted: Bool = true) {
        
        var output = "\n➡️➡️ [\(request.httpMethod ?? "")] \(request.url?.absoluteString ?? "")"
        
        if isHeaderPrinted, let headers = request.allHTTPHeaderFields {
            output += "\nHeaders: \(headers)"
        }
        
        if isBodyPrinted, let data = request.httpBody {
            output += "\nBody:"
            if let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                output += "\n\(dictionary)"
            } else if let bodyString = String(data: data, encoding: .utf8) {
                output += "\n\(bodyString)"
            }
        }
        
        Swift.print(output)
        
    }
    
    static func print(_ response: URLResponse, andData data: Data? = nil) {
        
        var output = "\n⬅️⬅️⬅️⬅️ [\((response as? HTTPURLResponse)?.statusCode ?? 0)] \(response.url?.absoluteString ?? "")"
        
        guard let data = data else { return }
        guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else {
            Swift.print("Failed to pretty print JSON")
            return
        }
        output += "\nResponse Body: \n\n\(prettyPrintedString)"
        
        Swift.print(output)
        
    }
    
    static func prettyPrint(_ json: Data) {
        guard let object = try? JSONSerialization.jsonObject(with: json, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else {
            Swift.print("Failed to pretty print JSON")
            return
        }
        Swift.print(prettyPrintedString)
    }
}

//
//  CheckoutAPI.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import Foundation

protocol CheckoutAPI {
    func checkout(cartItems: [CartItem]) async throws -> VoidDTO
}

class CheckoutAPIImpl: API, CheckoutAPI {
   
    actor SuccessFlag {
        private(set) var value: Bool = false

        func setValue(_ newValue: Bool) {
            value = newValue
        }
    }

    func checkout(cartItems: [CartItem]) async throws -> VoidDTO {
        
        try await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
        return VoidDTO()

        
        
        
        
        
//        let pollingURL = URL(string: "https://httpbin.org/delay/3")!
//        var maxWaitTime: TimeInterval = 15
//        let pollInterval: TimeInterval = 1
//        let startTime = Date()
//
//        let successFlag = SuccessFlag()
//
//        Task.detached {
//            do {
//                let (_, response) = try await URLSession.shared.data(from: pollingURL)
//                print("Success...")
//                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                    await successFlag.setValue(true)
//                }
//            } catch {
//                print("Polling attempt failed: \(error)")
//            }
//        }
//
//        var pollCount = 0
//       
//        while Date().timeIntervalSince(startTime) < maxWaitTime {
//            print("Poll...\(pollCount), interval: \(pollInterval)s")
//            pollCount += 1
//            
//            if await successFlag.value {
//                print("Polling successful!")
//                pollCount = 0
//                if maxWaitTime == 15 {
//                    maxWaitTime = 3
//                }
//                return VoidDTO()
//            }
//            try await Task.sleep(nanoseconds: UInt64(pollInterval * 1_000_000_000))
//        }
//
//        maxWaitTime = 15
//        throw APIError.timeout
    }
}

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

    private var checkoutResponseDelay = 5 // in seconds, for mocking the polling service

    func checkout(cartItems: [CartItem]) async throws -> VoidDTO {
        
        let pollingURL = URL(string: "https://httpbin.org/delay/\(checkoutResponseDelay)")!
        let maxWaitTime: TimeInterval = 7
        let pollInterval: TimeInterval = 2
        let startTime = Date()

        let successFlag = SuccessFlag()

        Task.detached {
            do {
                let (_, response) = try await URLSession.shared.data(from: pollingURL)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    await successFlag.setValue(true)
                }
            } catch {
                print("Polling attempt failed: \(error)")
            }
        }

        var pollCount = 0
       
        while Date().timeIntervalSince(startTime) < maxWaitTime {
            print("Poll...\(pollCount), interval: \(pollInterval)s")
            pollCount += 1
            
            
            if await successFlag.value {
                print("✅ Polling successful!")
                pollCount = 0
                if checkoutResponseDelay == 5 {
                    checkoutResponseDelay = 10
                }
                return VoidDTO()
            }
            try await Task.sleep(nanoseconds: UInt64(pollInterval * 1_000_000_000))
        }

        checkoutResponseDelay = 5
        throw APIError.timeout
    }
}

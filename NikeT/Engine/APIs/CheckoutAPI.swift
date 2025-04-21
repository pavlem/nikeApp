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
    
    func checkout(cartItems: [CartItem]) async throws -> VoidDTO {
        
        // 3 second delay from the "httpbin.org"
        let pollingURL = URL(string: "https://httpbin.org/delay/3")!
        
        // Max wait time is 10s
        let maxWaitTime: TimeInterval = 10
        
        // Poll interval in s
        let pollInterval: TimeInterval = 1
        let startTime = Date()
        
        // SuccessFlag ACTOR (not a CLASS) is used to safely share mutable state across concurrent tasks
        // Task.detached - this is one detached task (thread)
        // main polling loop is checking that flag in another task (thread)
        // this means two separate tasks (threads) are accessing and modifying the same variable (success flag) so we need synchronization.
        
        let successFlag = SuccessFlag()
        
        let pollingTask = Task.detached {
            do {
                // Intentionally I made this wait for 1s
                try await Task.sleep(nanoseconds: 1_000_000_000)
                print("Starting checkout call...")
                let (_, response) = try await URLSession.shared.data(from: pollingURL)
                print("Finished checkout call...")
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    await successFlag.setTrue()
                }
            } catch {
                print("Polling request failed: \(error)")
            }
        }
        
        while Date().timeIntervalSince(startTime) < maxWaitTime {
            print("Polling...")
            if await successFlag.get() {
                print("Polling successful!")
                return VoidDTO()
            }
            try await Task.sleep(nanoseconds: UInt64(pollInterval * 1_000_000_000))
        }
        
        print("request timed out, polling not successful!")
        pollingTask.cancel()
        throw APIError.timeout
    }
}

private actor SuccessFlag {
    private(set) var value: Bool = false
    
    func setTrue() { value = true }
    func get() -> Bool { value }
}

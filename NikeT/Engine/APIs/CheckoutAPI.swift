//
//  CheckoutAPI.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import Foundation

protocol CheckOutAPI {
    func checkOut() async throws -> VoidDTO
}

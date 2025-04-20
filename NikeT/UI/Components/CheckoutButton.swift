//
//  CheckoutButton.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import SwiftUI

// The button itself is already self-contained, and adding a ViewModel would only add unnecessary complexity.
// In general, we should use ViewModel is an app when you there is a need to manage state, data fetching, or complex business logic.

struct CheckoutButton: View {
    
    let title: String
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(isDisabled ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .disabled(isDisabled)
    }
}

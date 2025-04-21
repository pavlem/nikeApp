//
//  ProductDTO.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 19. 4. 2025..
//

import SwiftUI

private struct IsLoadingKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isLoading: Binding<Bool> {
        get { self[IsLoadingKey.self] }
        set { self[IsLoadingKey.self] = newValue }
    }
}

private struct LoadingViewModifier: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
    }
}

extension View {
    func loadingView(isLoading: Bool) -> some View {
        modifier(LoadingViewModifier(isLoading: isLoading))
    }
}

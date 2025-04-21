//
//  NikeTApp.swift
//  NikeT
//
//  Created by Pavle Mijatovic on 20. 4. 2025..
//

import SwiftUI

@main
struct NikeTApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: CartItem.self) // ← this is required
    }
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

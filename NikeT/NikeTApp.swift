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
    
    // this is because of a glitch (where the tab bar becomes translucent or disappears briefly during navigation) is a known UIKit/SwiftUI issue, especially when navigating inside a TabView. It happens because UITabBar is by default translucent.
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

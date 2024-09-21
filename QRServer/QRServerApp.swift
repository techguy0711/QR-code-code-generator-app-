//
//  QRServerApp.swift
//  QRServer
//
//  Created by Kristhian De Oliveira on 9/21/24.
//

import SwiftUI

@main
struct QRServerApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "house.fill")
                    }
                Faves()
                    .tabItem {
                        Image(systemName: "star.fill")
                    }
            }
        }
        .modelContainer(for: QRStore.self)
    }
}

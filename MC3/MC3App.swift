//
//  MC3App.swift
//  MC3
//
//  Created by Vanessa on 11/07/24.
//

import SwiftUI
import SwiftData

@main
struct MC3App: App {
    
    var body: some Scene {
        WindowGroup {
            LogoView()
        }
        .modelContainer(for: [User.self])
    }
}

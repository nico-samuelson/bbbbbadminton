//
//  ContentView.swift
//  watchFastFoot Watch App
//
//  Created by Vanessa on 16/07/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var watchToIOSConnector = WatchToIOSConnector()

    var body: some View {
        VStack {
            Text("Prediction: \(watchToIOSConnector.predicted)")
                .padding()
        }
        .background(backgroundColor(for: watchToIOSConnector.predicted))
        .onAppear {
            watchToIOSConnector.session.activate()
        }
    }

    private func backgroundColor(for prediction: String) -> Color {
        switch prediction {
        case "benar":
            return Color.green
        case "salah":
            return Color.red
        default:
            return Color.white
        }
    }
}

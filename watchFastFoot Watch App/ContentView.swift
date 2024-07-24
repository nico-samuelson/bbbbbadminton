//
//  ContentView.swift
//  watchFastFoot Watch App
//
//  Created by Vanessa on 16/07/24.
//
import Foundation
import SwiftUI
import WatchConnectivity



struct ContentView: View {
    @StateObject private var watchToIOSConnector = WatchToIOSConnector()

    var body: some View {
        VStack {
            Text(watchToIOSConnector.text)
                .font(.title2)
                .padding()
        }
    }
}


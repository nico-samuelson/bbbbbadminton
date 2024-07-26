//
//  TrainResultView.swift
//  watchFastFoot Watch App
//
//  Created by Dhammiko Dharmawan on 24/07/24.
//

import SwiftUI

struct TrainResultView: View {
    @ObservedObject var watchToIOSConnector: WatchToIOSConnector
    @Binding var isNavigatingBack: Bool
    
    // Computed property to extract the result substring
    var predictionResult: String {
        let components = watchToIOSConnector.text.split(separator: ":")
        guard components.count > 1 else { return "" }
        return components[1].trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        ZStack {
            // Background square box
            Rectangle()
                .fill(predictionResult == "benar" ? Color.green : (predictionResult == "salah" ? Color.red : Color.clear))
                .edgesIgnoringSafeArea(.all) // Make the box fill the whole screen
            
            // VStack on top
            VStack {
                Text(predictionResult)
                    .font(.title2)
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                
                HStack {
                    // Button for stopping recording
                    Button(action: {
                        watchToIOSConnector.sendMessage(["command": "stopRecording"])
                        isNavigatingBack = false // Navigate back to ContentView
                    }) {
                        Image(systemName: "stop.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(Color.white)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    TrainResultView(watchToIOSConnector: WatchToIOSConnector(), isNavigatingBack: .constant(false))
}








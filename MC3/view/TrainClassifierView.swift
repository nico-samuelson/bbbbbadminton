//
//  TrainClassifierView.swift
//  MC3
//
//  Created by Dhammiko Dharmawan on 17/07/24.
//

import SwiftUI

struct TrainClassifierView: View {
    @ObservedObject var predictionVM = PredictionViewModel()
    
    var switchCamera: some View {
        HStack {
            
            Spacer()
        }
    }
    
    var predictionLabels: some View {
        VStack {
            switchCamera
            Spacer()
            Text("Prediction: \(predictionVM.predicted)")
            Text("Confidence: \(predictionVM.confidence)")
        }
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: predictionVM.currentFrame ?? UIImage())
                .resizable()
                .scaledToFill()
            
            predictionLabels
        }
        .padding()
        .onAppear{
            predictionVM.updateUILabels(with: .startingPrediction)
        }
        // Detect if device change orientation
        .onReceive(
            NotificationCenter
                .default
                .publisher(for: UIDevice.orientationDidChangeNotification)) {
                    _ in
                    predictionVM.videoCapture.updateDeviceOrientation()
                }
    }
}

#Preview {
    TrainClassifierView()
}

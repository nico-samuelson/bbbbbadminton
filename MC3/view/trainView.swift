//
//  trainView.swift
//  MC3
//
//  Created by Vanessa on 14/07/24.
//
import SwiftUI
import AVKit

struct trainView: View {
    @StateObject var viewModel = TrainViewModel()

    var body: some View {
        VStack {
            // Video Player
            if let player = viewModel.player {
                VideoPlayer(player: player)
                    .frame(height: 600)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding()
            }

            Spacer()

            // Next Button
            Button(action: {
                viewModel.playNextVideo()
            }) {
                Text("Next Video")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 220, height: 55)
                    .background(Color.hex("#930F0D"))
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding()
            .disabled(viewModel.player == nil)

            Spacer()
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $viewModel.navigateToTutorialView) {
            startTutorialView()
        }
    }
}


#Preview {
    trainView()
}


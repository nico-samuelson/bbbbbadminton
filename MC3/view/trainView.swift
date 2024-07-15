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
                VideoPlayer(player: player) {
                    // Kontrol pemutaran (opsional)
                }
            }

            // Next Button
            Button(action: {
                viewModel.playNextVideo()
            }) {
                Text("Next Video")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.black)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
            }
            .disabled(viewModel.player == nil)
        }
        .navigationBarHidden(true)
    }
}


#Preview {
    trainView()
}

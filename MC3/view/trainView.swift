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
    @State var Classification_text: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                // Video Player
                if let player = viewModel.player {
                    VideoPlayer(player: player) {}
                    .frame(height: 600)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding()
                }

                // Next Button
                Button(action: {
                    viewModel.playNextVideo()
                }) {
                    Text("Next Video")
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .frame(width: 220, height: 55)
                        .background(Color.hex("#930F0D"))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()
                .disabled(viewModel.player == nil)
            }
            .navigationBarHidden(true)
            .background(Color.hex("#FAF9F6"))
            .navigationDestination(isPresented: .constant(viewModel.currentIndex >= viewModel.videoNames.count)) {
                startTutorialView()
            }
        }
    }
}


#Preview {
    trainView()
}

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
                    VideoPlayer(player: player) {
                        // Kontrol pemutaran (opsional)
                    }
                }

//                NavigationLink(
//                    destination: TrainClassifierView(),
//                    isActive: .constant(viewModel.currentIndex >= viewModel.videoNames.count)
//                    ) {
//                    EmptyView()
//                }
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
            .navigationDestination(isPresented: .constant(viewModel.currentIndex >= viewModel.videoNames.count)) {
                TrainClassifierView()
            }
        }
    }
}


#Preview {
    trainView()
}

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
                        .frame(width: 361, height: 44)
                        .background(Color.hex("#930F0D"))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()
                .disabled(viewModel.player == nil)
                // Skip Text
                                             NavigationLink(destination: startTutorialView()) {
                                                 Text("Skip")
                                                     .font(.system(size: 17))
                                                     .foregroundColor(Color("Accent"))
                                             }
                                             .bold()
                                             .padding()
                        
            }
            .navigationBarHidden(true)
            .background(Color("Primary").edgesIgnoringSafeArea(.all))
         
            .navigationDestination(isPresented: .constant(viewModel.currentIndex >= viewModel.videoNames.count)) {
                startTutorialView()
            }
        }
    }
}

#Preview {
    trainView()
}

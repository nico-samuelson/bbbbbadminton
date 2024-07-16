//
//  tutorialView.swift
//  MC3
//
//  Created by Vanessa on 15/07/24.
//

import SwiftUI
import AVKit

struct tutorialView: View {
    @StateObject var viewModel = TutorialViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if let player = viewModel.player {
                    VideoPlayer(player: player)
                        .frame(height: 600)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                        .padding()
                }

                Spacer()

                NavigationLink(destination: cameraView()) {
                    Text("Start Training")
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
        }
    }
}

#Preview {
    tutorialView()
}

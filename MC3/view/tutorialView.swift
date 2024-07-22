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
        NavigationStack {
            VStack {
                if let player = viewModel.player {
                    VideoPlayer(player: player)
                        .frame(height: 600)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                        .padding()
                }

                Spacer()

                NavigationLink(destination: TrainClassifierView()) {
                    Text("Start Training")
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .frame(width: 361, height: 44)
                        .background(Color.hex("#930F0D"))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()
                .disabled(viewModel.player == nil)

                Spacer()
            }
            .navigationBarHidden(true)
            .background(Color.hex("#FAF9F6"))
        }
    }
}

#Preview {
    tutorialView()
}

import Foundation
import SwiftUI
import AVKit

struct RecordedVideosView: View {
    @ObservedObject var predictionVM: PredictionViewModel

    var body: some View {
        NavigationStack {
            VStack {
                List(predictionVM.getSavedVideoURLs(), id: \.self) { url in
                    let fileName = url.lastPathComponent
                    Text(fileName)
                        .onTapGesture {
                            // Handle video playback
                            playVideo(from: url)
                        }
                }
            }
            .navigationBarTitle("Recorded Videos")
        }
    }

    private func playVideo(from url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        UIApplication.shared.windows.first?.rootViewController?
            .present(playerViewController, animated: true) {
                player.play()
            }
    }
}

import SwiftUI
import AVKit

struct Video {
    let name: String
    let fileName: String
}


struct VideoListView: View {
    let videos: [Video] = [
        Video(name: "Video 1", fileName: "footwork"),
        Video(name: "Video 2", fileName: "footwork"),
        Video(name: "Video 3", fileName: "footwork")
    ]
    
    @State private var selectedVideo: Video?
    
    var body: some View {
        VStack {
            Text("List of Videos")
                .font(.title)
                .padding()
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(videos, id: \.fileName) { video in
                        Button(action: {
                            self.selectedVideo = video
                        }) {
                            VStack(alignment: .leading) {
                                Text(video.name)
                                    .font(.headline)
                                // Jika Anda memiliki thumbnail, tampilkan di sini
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.red)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            
            if let selectedVideo = selectedVideo {
                VideoPlayerView(videoURL: Bundle.main.url(forResource: selectedVideo.fileName, withExtension: "mp4")!)
                    .frame(height: 300)
                    .edgesIgnoringSafeArea(.all)
            }
            
            Spacer()
        }
        .navigationBarTitle("Exercise Videos", displayMode: .inline)
    }
}

struct VideoPlayerView: UIViewControllerRepresentable {
    let videoURL: URL
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Tidak ada yang perlu diperbarui di sini
    }
}

#Preview {
    NavigationView {
        VideoListView()
    }
}

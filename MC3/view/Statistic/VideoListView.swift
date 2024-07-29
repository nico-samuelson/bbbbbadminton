import SwiftUI
import AVKit

struct Video: Identifiable, Hashable {
    let id: UUID
    let title: String
    let fileName: String
    let fileType: String
}

struct VideoListView: View {
    @State private var selectedVideo: String? = nil
    
    @State private var player: AVPlayer? = nil
    var exercise: Exercise = Exercise()
    
    init(exercise: Exercise) {
        self.exercise = exercise
    }

    var body: some View {
        VStack {
            if let selectedVideo = selectedVideo, let videoURL = URL(string: selectedVideo) {
                VideoPlayer(player: player)
                    .frame(maxHeight: 200)
                    .onAppear {
                        player = AVPlayer(url: videoURL)
                        player?.play()
                    }
            } else {
                Spacer()
                Text("Pilih video untuk diputar")
                    .frame(width: 400, height: 200)
                    .background(Color.gray.opacity(0.3))
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("June 30, 2024")
                        .font(.system(size: 13))
                        .padding(.bottom, 12)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(formatDuration(Int(exercise.duration)))")
                                .bold()
                                .font(.system(size: 22))
                            Text("Time")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 32)
                        
//                        VStack(alignment: .leading) {
//                            Text("\(exercise.mistakes.count)")
//                                .bold()
//                                .font(.system(size: 22))
//                            Text("Reps")
//                                .font(.system(size: 13))
//                                .foregroundColor(.gray)
//                        }
//                        .padding(.horizontal, 32)
                        VStack(alignment: .leading) {
                            Text("\(Int(exercise.accuracy * 100)) %")
                                .bold()
                                .font(.system(size: 22))
                            Text("Accuracy")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.top, 22)
                .padding(.horizontal, 16)
                Spacer()
            }
            
            HStack {
                Text("Your Mistake")
                    .bold()
                    .font(.system(size: 26))
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 26)
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    ForEach(exercise.mistakes, id: \.self) { video in
                        let namaFile = extractFileName(from: video)
                        NavigationLink(destination: VideoPlaybackView(url: video)) {
                            Text(namaFile)
                                .foregroundStyle(Color("Accent"))
                        }
                        
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                
                    }
                }
            }
            .padding()
        }
        .onAppear {
            selectedVideo = exercise.fullRecord
        }
        .navigationTitle("Exercise Detail")
    }
}
func extractFileName(from url: String) -> String {
    // Pisahkan URL berdasarkan "/"
    let components = url.components(separatedBy: "/")
    // Ambil komponen terakhir (nama file dengan ekstensi)
    if let fileNameWithExtension = components.last {
        // Pisahkan nama file berdasarkan "_" dan ambil bagian pertama (nama file sebelum "_")
        let nameParts = fileNameWithExtension.components(separatedBy: "_")
        return nameParts.first ?? ""
    }
    return ""
}

func formatDuration(_ seconds: Int) -> String {
    let hour = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let seconds = seconds % 60
    
    return "\(hour):\(minutes):\(seconds)"
}

private func playVideo(from url: URL) {
    let player = AVPlayer(url: url)
    let playerViewController = AVPlayerViewController()
    playerViewController.player = player
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let rootViewController = windowScene.windows.first?.rootViewController {
        rootViewController.present(playerViewController, animated: true) {
            player.play()
        }
    }
}

func createLocalUrl(for filename: String, ofType type: String) -> URL? {
    let fileManager = FileManager.default
    let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let url = cacheDirectory.appendingPathComponent("\(filename).\(type)")

    guard fileManager.fileExists(atPath: url.path) else {
        guard let video = NSDataAsset(name: filename) else { return nil }
        do {
            try video.data.write(to: url)
            print("Video written to URL: \(url)")
            return url
        } catch {
            print("Error writing video data:", error.localizedDescription)
            return nil
        }
    }

    return url
}

#Preview {
    NavigationView {
        VideoListView(exercise: Exercise())
    }
}

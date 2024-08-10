import SwiftUI
import AVKit

struct Video: Identifiable, Hashable {
    let id: UUID
    let title: String
    let fileName: String
    let fileType: String
}

struct ExerciseDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedVideo: String? = nil
    @State private var durations: [Int] = []
    @State private var player: AVPlayer? = nil
    var exercise: Exercise = Exercise()
    
    init(exercise: Exercise) {
        self.exercise = exercise
    }
    
    func generateThumbnail(from url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true // Correctly orient the thumbnail
        
        let time = CMTime(seconds: 1.0, preferredTimescale: 600) // Capture the thumbnail at 1 second
        
        do {
            let cgImage = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getVideoDurations() async {
        for mistake in exercise.mistakes {
            guard let url = URL(string: mistake) else {
                continue
            }
            
            let asset = AVAsset(url: url)
            var duration: Double = 0
            do {
                duration = try await asset.load(.duration).seconds
            }
            catch {
                print("error getting video duration")
            }
            
            durations.append(Int(duration))
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
    
    func formatDuration(_ seconds: Int, _ withHour: Bool = true) -> String {
        let hour = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        
        return withHour ? "\(hour):\(minutes):\(seconds)" : "\(minutes):\(seconds)"
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
    
    var body: some View {
        VStack {
            if let selectedVideo = selectedVideo, let videoURL = URL(string: selectedVideo) {
                VideoPlayer(player: player)
                    .frame(maxHeight: 200)
                    .scaledToFill()
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
                    ForEach(Array(exercise.mistakes.enumerated()), id: \.element) { index, video in
                        let namaFile = extractFileName(from: video)
                        
                        NavigationLink(destination: MistakePlaybackView(url: video)) {
                            HStack(alignment: .center) {
                                if let thumbnail = generateThumbnail(from: URL(string: video)!) {
                                    Image(uiImage: thumbnail)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 80)
                                }
                                else {
                                    Rectangle()
                                        .frame(width: 120, height: 80)
                                        .foregroundStyle(colorScheme == .light ? Color.hex("#E3E5E5") : Color("Text").opacity(0.1))
                                        .overlay(
                                            Image(systemName: "play.slash.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 30, height: 30)
                                                .foregroundStyle(colorScheme == .light ? Color("Gray") : Color.hex("#888888"))
                                                .background(Color.clear)
                                        )
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("\(namaFile) #\(index + 1)")
                                        .foregroundStyle(Color("Accent"))
                                        .cornerRadius(12)
                                        .multilineTextAlignment(.leading)
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                    
                                    Text(durations.count > index ? formatDuration(durations[index], false) : "0")
                                        .cornerRadius(12)
                                        .font(.system(size: 13))
                                        .foregroundStyle(Color("Text"))
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                }
                                .padding(.leading, 16)
                            }
                        }
                        .frame(maxWidth: .infinity, idealHeight: 80)
                        .background(colorScheme == .dark ? Color("Text").opacity(0.1) : Color.white)
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .background(Color("Primary"))
        .onAppear {
            selectedVideo = exercise.fullRecord
            
            Task {
                await getVideoDurations()
            }
        }
        .navigationTitle("Exercise Detail")
        .background(Color("Secondary"))
    }
}

#Preview {
    NavigationView {
        ExerciseDetailView(exercise: Exercise())
    }
}

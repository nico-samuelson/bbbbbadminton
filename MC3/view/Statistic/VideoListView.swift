import SwiftUI
import AVKit

struct Video: Identifiable, Hashable {
    let id: UUID
    let title: String
    let fileName: String
    let fileType: String
}

struct VideoListView: View {
    let videos: [Video] = [
        Video(id: UUID(), title: "Footwork", fileName: "footwork", fileType: "mov"),
        Video(id: UUID(), title: "pakai apple watch", fileName: "pakai apple watch", fileType: "mov"),
        Video(id: UUID(), title: "nge set kamera", fileName: "nge set kamera", fileType: "mov"),
        Video(id: UUID(), title: "area", fileName: "footwork", fileType: "mov"),
        // Tambahkan video lainnya di sini
    ]
    @State private var selectedVideo: Video? = nil
    @State private var player: AVPlayer? = nil
    
    @ObservedObject var predictionVM: PredictionViewModel

    var body: some View {
        VStack {
            if let selectedVideo = selectedVideo, let videoURL = createLocalUrl(for: selectedVideo.fileName, ofType: selectedVideo.fileType) {
                VideoPlayer(player: player)
                    .frame(maxHeight: 200)
                    .onAppear {
                        player?.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
                        player?.play()
                    }
            }  else {
                Spacer()
                Text("Pilih video untuk diputar")
                    .frame(width :400 ,height: 200)
                    .background(Color.gray.opacity(0.3))
            }
            
            Button("Tombol") {
                print(predictionVM.getSavedVideoURLs())
            }
            
            HStack {
                VStack (alignment:.leading){
                    Text("June 30, 2024")
                        .font(.system(size: 13))
                        .padding(.bottom,12)
                    HStack{
                        VStack(alignment: .leading){
                            Text("0:10:05")
                                .bold()
                                .font(.system(size: 22))
                            Text("Time")
                                .font(.system(size: 13))
                                .foregroundStyle(.gray)
                            
                        }
                        
                        VStack(alignment: .leading){
                            Text("10")
                                .bold()
                                .font(.system(size: 22))
                            Text("Reps")
                                .font(.system(size: 13))
                                .foregroundStyle(.gray)
                        }
                        .padding(.horizontal,32)
                        VStack(alignment: .leading){
                            Text("05")
                                .bold()
                                .font(.system(size: 22))
                            Text("Accuracy")
                                .font(.system(size: 13))
                                .foregroundStyle(.gray)
                        }
                        
                    }
                }
                .padding(.top,22)
                .padding(.horizontal,16)
                Spacer()
            }
            
            HStack{
                
                Text("Your Mistake")
                    .bold()
                    .font(.system(size: 26))
                
                Spacer()
            }
            .padding(.horizontal,16)
            .padding(.top,26)
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    ForEach(videos, id: \.self) { video in
                        
                        Button(action: {
                            selectedVideo = video
                            if let videoURL = createLocalUrl(for: video.fileName, ofType: video.fileType) {
                                player = AVPlayer(url: videoURL)
                                player?.play()
                            } else {
                                print("Video URL not found for file: \(video.fileName).\(video.fileType)")
                            }
                        }) {
                            
                            VStack{
                                Text(video.title)
                                Text(video.title)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .foregroundStyle(.red)
                            
//                            Text(video.title)
                        }
                    }
                }
            }
            .padding()
            .onAppear(perform: {
                    predictionVM.getSavedVideoURLs()
            })
        }
        .navigationTitle("Exercise Detail")
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
        VideoListView(predictionVM: PredictionViewModel())
    }
}

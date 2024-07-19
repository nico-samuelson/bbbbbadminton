import SwiftUI
import AVKit

struct TrainClassifierView: View {
    @ObservedObject var predictionVM = PredictionViewModel()
    @State private var isShowingRecordedVideos = false
    @State var isRecording = false
    
    var switchCamera: some View {
        HStack {
            Spacer()
        }
    }
    
    var predictionLabels: some View {
        VStack {
            Spacer()
            Text("Prediction: \(predictionVM.predicted)").foregroundStyle(Color.white)
            Text("Confidence: \(predictionVM.confidence)").foregroundStyle(Color.white)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Image(uiImage: predictionVM.currentFrame ?? UIImage())
                        .resizable()
                        .scaledToFill()
                    
                    Button {
                        isRecording = !isRecording
                        
                        isRecording ? predictionVM.startRecording() : predictionVM.stopRecording()
                    } label: {
                        Image(systemName: isRecording ? "stop.fill" : "play.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(Color.white)
                    }
                    
                    predictionLabels
                }
                .padding()
                .onAppear {
                    predictionVM.updateUILabels(with: .startingPrediction)
                }
                .onReceive(
                    NotificationCenter
                        .default
                        .publisher(for: UIDevice.orientationDidChangeNotification)) {
                            _ in
                            predictionVM.videoCapture.updateDeviceOrientation()
                        }
                        .navigationDestination(isPresented: $isShowingRecordedVideos) {
                            RecordedVideosView(predictionVM: predictionVM)
                        }
                
                Button(action: {
                    isShowingRecordedVideos = true
                }) {
                    Text("View Recorded Videos")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .toolbar(.hidden)
        }
    }
}
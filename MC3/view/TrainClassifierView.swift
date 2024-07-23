import SwiftUI
import AVKit

struct TrainClassifierView: View {
    @ObservedObject var predictionVM = PredictionViewModel()
    @State private var isShowingRecordedVideos = false
    @State var isRecording = false
    @State private var isPortrait = true // State to track orientation

    var predictionLabels: some View {
        VStack {
            Spacer()
            Text("Prediction: \(predictionVM.predicted)").foregroundStyle(Color.white).fontWeight(.bold)
            Text("Confidence: \(predictionVM.confidence)").foregroundStyle(Color.white).fontWeight(.bold)
        }
        .padding(.bottom, 32)
    }
    
    var calibrationMessage: some View {
        VStack {
            Spacer()
            Text(predictionVM.calibrationMessage).foregroundStyle(Color.white).fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 32)
    }
    
    var body: some View {
        GeometryReader { gr in
            VStack {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                    Image(uiImage: predictionVM.currentFrame ?? UIImage())
                        .resizable()
                        .frame(width: gr.size.width, height: gr.size.height)
                        .padding(.zero)
                        .scaledToFit()
                    
                    !isRecording ? Rectangle()
                        .frame(width: gr.size.width * 0.25, height: gr.size.height)
                        .border(predictionVM.isCentered ? Color.green : Color.red, width: 3)
                        .foregroundStyle(Color.white.opacity(0))
                        .backgroundStyle(Color.white.opacity(0)) : nil
                    
                    ((predictionVM.isCentered && !isRecording) || isRecording) ? Button {
                        isRecording = !isRecording
                        
                        if isRecording {
                            predictionVM.startRecording()
                        } else {
                            predictionVM.stopRecording()
                            isShowingRecordedVideos = true
                        }
                    } label: {
                        Image(systemName: isRecording ? "stop.fill" : "play.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(Color.white)
                    } : nil

                    if isRecording {
                        predictionLabels
                    }
                    else {
                        calibrationMessage
                    }

                    // Overlay for rotation prompt
                    if isPortrait {
                        Rectangle()
                            .fill(Color.black.opacity(0.7))
                            .edgesIgnoringSafeArea(.all)
                            .overlay(
                                Text("Please rotate your phone")
                                    .rotationEffect(.degrees(90))
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding()
                            )
                    }
                }
                .onAppear {
                    predictionVM.updateUILabels(with: .startingPrediction)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    let orientation = UIDevice.current.orientation
                    isPortrait = orientation.isPortrait
                    predictionVM.videoCapture.updateDeviceOrientation()
                }
                .navigationDestination(isPresented: $isShowingRecordedVideos) {
                    RecordedVideosView(predictionVM: predictionVM)
                }
            }
            .ignoresSafeArea(.all)
        }
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TrainClassifierView()
}

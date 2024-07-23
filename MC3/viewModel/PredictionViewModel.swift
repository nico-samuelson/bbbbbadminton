//
//  PredictionViewModel.swift
//  MC3
//
//  Created by Dhammiko Dharmawan on 17/07/24.
//

import SwiftUI
import WatchConnectivity

class PredictionViewModel: ObservableObject {
    @Published var currentFrame: UIImage?
    @Published var predicted: String = ""
    @Published var confidence: String = ""
    @Published var savedPrediction: String = ""
    
    var videoCapture: VideoCapture!
    var videoProcessingChain: VideoProcessingChain!
    var actionFrameCounts = [String: Int]()
    
    var fullVideoWriter: VideoWriter?
    var videoWriters = [VideoWriter?]()
    var currentVideoWriter: VideoWriter?
    var currentLabel: String = ""
    var isRecording: Bool = false
    
    init() {
        videoProcessingChain = VideoProcessingChain()
        videoProcessingChain.delegate = self
        videoCapture = VideoCapture()
        videoCapture.delegate = self
    }
    
    func updateUILabels(with prediction: ActionPrediction) {
        DispatchQueue.main.async {
            self.predicted = prediction.label
            self.confidence = prediction.confidenceString ?? "Observing..."
        }
        
        manageVideoWriter(for: prediction.label)
    }
    func savePrediction() {
          savedPrediction = predicted
      }
    func sendPredictionToWatch() {
            if WCSession.default.isReachable {
                let message = ["predicted": predicted]
                WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                    print("Error sending message to Watch: \(error.localizedDescription)")
                })
            }
        }
    
    func getSavedVideoURLs() -> [URL] {
        var videos = videoWriters.compactMap { $0?.outputURL }
        
        guard let fullVideoURL = fullVideoWriter else { return videos }
        videos.append(fullVideoURL.outputURL)
        
        return videos
    }
    
    private func manageVideoWriter(for label: String = "") {
        if label != currentLabel && isRecording {
            currentLabel = label
            
            // end current video recording
            currentVideoWriter?.finishWriting {
                print("Finished writing video for \(self.currentLabel)")
            }
            
            // discard recorded video if duration is less than 2s
            if currentVideoWriter?.frameCount ?? 0 >= 60 && !videoWriters.compactMap({ $0?.outputURL }).contains(currentVideoWriter?.outputURL) {
                print("video not discarded")
                videoWriters.append(currentVideoWriter)
            }
            
            // record new video
            if label == "benar" || label == "salah" {
                let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(label)_\(Date().timeIntervalSince1970).mov")
                let clippedVideo = VideoWriter(outputURL: outputURL, frameSize: CGSize(width: 1920, height: 1080))
                clippedVideo?.startWriting()
                currentVideoWriter = clippedVideo
            }
        }
    }
    
    func startRecording() {
        isRecording = true
        
        // start full exercise recording
        fullVideoWriter = VideoWriter(outputURL: URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("full_\(Date().timeIntervalSince1970).mov"), frameSize: CGSize(width: 1920, height: 1080))
        fullVideoWriter?.startWriting()
    }
    
    func stopRecording() {
        isRecording = false
        
        // finish all recording
        fullVideoWriter?.finishWriting {
            print("Finalized full video recording at \(String(describing: self.fullVideoWriter?.outputURL.lastPathComponent))")
        }
        for writer in videoWriters {
            writer?.finishWriting {
                print("Finalized video for \(String(describing: writer?.outputURL.lastPathComponent))")
            }
        }
    }
    
    deinit {
        stopRecording()
    }

    private func addFrameCount(_ frameCount: Int, to actionLabel: String) {
        let totalFrames = (actionFrameCounts[actionLabel] ?? 0) + frameCount
        actionFrameCounts[actionLabel] = totalFrames
    }
    
    private func drawPoses(_ poses: [Pose]?, onto frame: CGImage) {
        let renderFormat = UIGraphicsImageRendererFormat()
        renderFormat.scale = 1.0

        let frameSize = CGSize(width: frame.width, height: frame.height)
        let poseRenderer = UIGraphicsImageRenderer(size: frameSize, format: renderFormat)

        let frameWithPosesRendering = poseRenderer.image { rendererContext in
            let cgContext = rendererContext.cgContext
            let inverse = cgContext.ctm.inverted()
            cgContext.concatenate(inverse)
            let imageRectangle = CGRect(origin: .zero, size: frameSize)
            cgContext.draw(frame, in: imageRectangle)

            let pointTransform = CGAffineTransform(scaleX: frameSize.width, y: frameSize.height)
            guard let poses = poses else { return }

            for pose in poses {
                pose.drawWireframeToContext(cgContext, applying: pointTransform)
            }
        }

        DispatchQueue.main.async {
            self.currentFrame = frameWithPosesRendering
            self.fullVideoWriter?.addFrame(frameWithPosesRendering)
            self.currentVideoWriter?.addFrame(frameWithPosesRendering)
        }
    }
}

extension PredictionViewModel: VideoCaptureDelegate {
    func videoCapture(_ videoCapture: VideoCapture, didCreate framePublisher: FramePublisher) {
        updateUILabels(with: .startingPrediction)
        videoProcessingChain.upstreamFramePublisher = framePublisher
    }
}

extension PredictionViewModel: VideoProcessingChainDelegate {
    func videoProcessingChain(_ chain: VideoProcessingChain,
                              didPredict actionPrediction: ActionPrediction,
                              for frames: Int) {
        if actionPrediction.isModelLabel {
            addFrameCount(frames, to: actionPrediction.label)
        }
        DispatchQueue.main.async { self.updateUILabels(with: actionPrediction) }
    }
    
    func videoProcessingChain(_ chain: VideoProcessingChain,
                              didDetect poses: [Pose]?,
                              in frame: CGImage) {
        self.drawPoses(poses, onto: frame)
    }
}

//
//  cameraView.swift
//  MC3
//
//  Created by Vanessa on 15/07/24.
//

import SwiftUI
import AVFoundation

class CameraViewModel: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()

    @Published var isRecording = false
    @Published var outputURL: URL?

    override init() {
        super.init()
        setupCamera()
    }

    func setupCamera() {
        guard let camera = AVCaptureDevice.default(for: .video) else {
            print("Error: Unable to access camera.")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }

            if captureSession.canAddOutput(movieOutput) {
                captureSession.addOutput(movieOutput)
            }

            captureSession.startRunning()
        } catch {
            print("Error setting up camera input: \(error.localizedDescription)")
        }
    }

    func startRecording() {
        guard let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("output.mov") else {
            print("Error: Could not create output URL.")
            return
        }

        self.outputURL = outputURL
        movieOutput.startRecording(to: outputURL, recordingDelegate: self)
    }

    func stopRecording() {
        movieOutput.stopRecording()
    }

    // MARK: - AVCaptureFileOutputRecordingDelegate

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error recording video: \(error.localizedDescription)")
            return
        }
        print("Video recorded successfully. File saved at: \(outputFileURL)")
    }
}

struct cameraView: View {
    @StateObject private var viewModel = CameraViewModel()

    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.captureSession)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                HStack {
                    Spacer()
                    RecordButton(viewModel: viewModel)
                        .padding()
                    Spacer()
                }
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    var session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the preview layer if needed
    }
}

struct RecordButton: View {
    @ObservedObject var viewModel: CameraViewModel

    var body: some View {
        Button(action: {
            if self.viewModel.isRecording {
                self.viewModel.stopRecording()
            } else {
                self.viewModel.startRecording()
            }
            self.viewModel.isRecording.toggle()
        }) {
            Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "circle.fill")
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundColor(viewModel.isRecording ? .red : .red)
                .padding()
        }
    }
}


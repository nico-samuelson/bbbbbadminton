import UIKit
import AVFoundation
import Vision

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var videoOutput: AVCaptureVideoDataOutput!
    var footworkClassifier: VNCoreMLModel!
    var frameCounter = 0
    var classificationHandler: ((String) -> Void)?
    private let captureSession = AVCaptureSession()
    lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    private let cameraView = UIView(frame: .zero)
    private let videoDataOutputQueue = DispatchQueue(
        label: "CameraFeedOutput",
        qos: .userInteractive
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the Core ML model
        guard let model = try? FootworkClassifier(configuration: MLModelConfiguration()).model else { return }
        guard let vnModel = try? VNCoreMLModel(for: model) else { return }
        self.footworkClassifier = vnModel
        
        setupView()
        configureCamera()
        startCaptureSession()
        previewLayer.connection?.videoOrientation = .portrait
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = cameraView.bounds
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(cameraView)
        cameraView.clipsToBounds = true
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureCamera() {
        guard let device = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .back).devices.first else {
            fatalError("No back camera device found, please make sure to run this on an iOS device and not a simulator")
        }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        captureSession.addInput(cameraInput)
        
        // setup device frame rate
        do {
            try device.lockForConfiguration()
            device.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 30)
            device.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: 30)
//            device.configurefr
            device.unlockForConfiguration()
        } catch {
            print("Error setting frame rate: \(error)")
        }
    }
    
    private func startCaptureSession() {
        let dataOutput = AVCaptureVideoDataOutput()
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        }
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoRotationAngle = 0
        cameraView.layer.addSublayer(previewLayer)
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        frameCounter += 1
        
        // Only perform the request every 90 frames
        if frameCounter % 90 != 0 {
            return
        }
        
        // Reset the frame counter
        frameCounter = 0
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Create a request to classify the frame
        let request = VNCoreMLRequest(model: footworkClassifier) { finishedRequest, error in
            print(finishedRequest)
            print(error)
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            guard let firstResult = results.first else { return }
            
            DispatchQueue.main.async {
                // Call the classification handler to update the SwiftUI view
                self.classificationHandler?(firstResult.identifier)
            }
        }
        
        // Perform the request
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}

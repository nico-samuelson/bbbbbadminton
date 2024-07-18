//import SwiftUI
//import AVFoundation
//
//struct CameraView: UIViewControllerRepresentable {
//    @State var classificationLabel: String = ""
//
//    func makeUIViewController(context: Context) -> CameraViewController {
//        let viewController = CameraViewController()
//        viewController.classificationHandler = { label in
//            DispatchQueue.main.async {
//                self.classificationLabel = label
//            }
//        }
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
//}
//
////#Preview {
////    CameraView(classificationLabel: <#T##Binding<String>#>)
////}

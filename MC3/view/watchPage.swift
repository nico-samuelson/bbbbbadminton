//
//  watchPage.swift
//  MC3
//
//  Created by Dhammiko Dharmawan on 23/07/24.
//

import SwiftUI
import WatchConnectivity

//class WatchSessionManager: NSObject, WCSessionDelegate, ObservableObject {
//    static let shared = WatchSessionManager()
//    private override init() {
//        super.init()
//        if WCSession.isSupported() {
//            WCSession.default.delegate = self
//            WCSession.default.activate()
//        }
//    }
//    
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
//    
//    func sessionDidBecomeInactive(_ session: WCSession) {}
//    
//    func sessionDidDeactivate(_ session: WCSession) {
//        session.activate()
//    }
//    
//    func sendMessage(_ message: [String: Any]) {
//        if WCSession.default.isReachable {
//            WCSession.default.sendMessage(message, replyHandler: nil) { error in
//                print("Error sending message: \(error.localizedDescription)")
//            }
//        }
//    }
//}

//struct watchPage: View {
//    @State private var count = 0
//    
//    var body: some View {
//        VStack {
//            Button(action: {
//                count += 1
//                let message = ["count": count]
//                WatchSessionManager.shared.sendMessage(message)
//            }) {
//                Text("Press me")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//            
//            Text("Count: \(count)")
//                .font(.largeTitle)
//                .padding()
//        }
//    }
//}
//
//#Preview {
//    watchPage()
//}

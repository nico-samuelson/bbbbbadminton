//
//  watchToIOSConnector.swift
//  watchFastFoot Watch App
//
//  Created by Vanessa on 16/07/24.
//

import Foundation
import WatchConnectivity
import SwiftUI

class WatchToIOSConnector: NSObject, ObservableObject, WCSessionDelegate {
    @Published var text: String = "Hello worlds"
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let predicted = message["predicted"] as? String {
            DispatchQueue.main.async {
                self.text = "Prediction: \(predicted)"
            }
        }
    }
}


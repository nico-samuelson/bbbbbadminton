//
//  watchToIOSConnector.swift
//  watchFastFoot Watch App
//
//  Created by Vanessa on 16/07/24.
//

import Foundation
import WatchConnectivity
import SwiftUI

class WatchToIOSConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    var session: WCSession
    @Published var predicted: String = ""

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let predicted = message["predicted"] as? String {
            DispatchQueue.main.async {
                self.predicted = predicted
            }
        }
    }
}


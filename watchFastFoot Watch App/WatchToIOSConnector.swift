//
//  watchToIOSConnector.swift
//  watchFastFoot Watch App
//
//  Created by Vanessa on 16/07/24.
//

import Foundation
import WatchConnectivity

class WatchToIOSConnector: NSObject, WCSessionDelegate {
   
    var session: WCSession
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sendMacroToIOS() {
        
    }
    
}

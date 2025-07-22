//
//  FitTagWatchApp.swift
//  FitTagWatch Watch App
//
//  Created by Luca Zorzi on 17/05/25.
//

import SwiftUI
import WatchConnectivity

@main
struct FitTagWatch_Watch_AppApp: App {
    
    init() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = WatchConnectivityManager.shared
            session.activate()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

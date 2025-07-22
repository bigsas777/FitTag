//
//  FitTagWatchApp.swift
//  FitTagWatch Watch App
//
//  Created by Luca Zorzi on 17/05/25.
//

import SwiftUI
import WatchConnectivity
import HealthKit

@main
struct FitTagWatch_Watch_AppApp: App {
    init() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = WatchConnectivityManager.shared
            session.activate()
        }
        
        if HKHealthStore.isHealthDataAvailable() {
            let healthStore = HKHealthStore()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

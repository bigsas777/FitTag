//
//  FitTagApp.swift
//  FitTag
//
//  Created by Luca Zorzi on 19/04/25.
//

import SwiftUI
import FirebaseCore
import WatchConnectivity

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
  }
}

@main
struct FitTagApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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

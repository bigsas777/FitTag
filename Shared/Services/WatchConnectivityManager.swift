//
//  WatchConnectivityManager.swift
//  FitTag
//
//  Created by Luca Zorzi on 23/05/25.
//

import Foundation
import WatchConnectivity


final class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    
    static let shared = WatchConnectivityManager()
    
    #if os(iOS)
    private let firestoreManager = FirestoreManager()
    #endif
    
    @Published var savedActivity: [String] = []
    
    override private init() {
        super.init()
        
        guard WCSession.isSupported() else {
            return
        }
        
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func sendActivity(_ activity: Activity) {
        do {
            let data = try JSONEncoder().encode(activity)
            let userInfo: [String: Any] = ["activity": data]
            WCSession.default.transferUserInfo(userInfo)
        } catch {
            print("Errore durante l'encoding dell'activity: \(error)")
        }
    }
    
    // Ricezione attività
    #if os(iOS)
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let data = userInfo["activity"] as? Data {
            do {
                let activity = try JSONDecoder().decode(Activity.self, from: data)
                DispatchQueue.main.async {
                    self.firestoreManager.saveActivity(activity)
                }
            } catch {
                print("Errore nel decoding dell'activity: \(error)")
            }
        }
    }
    #endif
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession attivata con stato: \(activationState.rawValue)")
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
        
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    #endif
}

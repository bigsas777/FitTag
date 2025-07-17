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
    
    /*override private init() {
        super.init()
    }*/
    
    #if os(watchOS)
    func sendActivity(_ activity: Activity, timestamp: String) {
        guard WCSession.default.isReachable || WCSession.default.activationState == .activated else {
            print("WCSession non attivo o non raggiungibile")
            return
        }
        
        do {
            // Encoding JSON
            let data = try JSONEncoder().encode(activity)
            
            // Salvo come JSON temporaneo
            let fm = FileManager.default
            let activityPath = fm.temporaryDirectory.appendingPathComponent("activity-\(timestamp).json")
            guard fm.createFile(atPath: activityPath.path(), contents: data, attributes: nil) else {
                print("Errore nel salvataggio del file")
                return
            }
        } catch {
            print("Errore durante l'encoding dell'activity: \(error)")
        }
    }
    #endif
    
    // Ricezione attività
    #if os(iOS) // TODO: modificare ricezione per i files
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

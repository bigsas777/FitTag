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
    }
    
    #if os(watchOS)
    func sendActivity(_ activity: Activity, timestamp: String) {
        do {
            // Encoding JSON
            let data = try JSONEncoder().encode(activity)
            
            // Salvo come JSON temporaneo
            let fm = FileManager.default
            let activityPath = fm.temporaryDirectory.appendingPathComponent("activity-\(timestamp).json")
            
            try data.write(to: activityPath)
            
            // Invio del file all'iPhone
            let transfer = WCSession.default.transferFile(activityPath, metadata: nil)
            
        } catch {
            print("Errore durante l'encoding dell'activity: \(error)")
        }
    }
    #endif
    
    // Ricezione attività
    #if os(iOS)
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let url = file.fileURL
        do {
            let data = try Data(contentsOf: url)
            let activity = try JSONDecoder().decode(Activity.self, from: data)
            DispatchQueue.main.async {
                self.firestoreManager.saveActivity(activity)
            }
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Errore nella lettura, decodifica o rimozione del file: \(error)")
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

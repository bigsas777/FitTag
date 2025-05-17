//
//  FirestoreManager.swift
//  FitTag
//
//  Created by Luca Zorzi on 21/04/25.
//

import Foundation
import FirebaseFirestore

class FirestoreManager: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var savingError = false
    @Published var fetchingError = false
    
    func saveActivity(_ activity: Activity) {
        var activityToSave = activity // variabile ausiliaria pk i parametri passati sono let e nn potrei assegnargli id
        let activityRef = db.collection("activities").document()
        activityToSave.id = activityRef.documentID
        
        let activitySummary = ActivitySummary(from: activityToSave)
        
        do {
            try activityRef.setData(from: activityToSave)
            try db.collection("activitySummaries").document().setData(from: activitySummary)
        } catch {
            savingError = true
        }
    }
    
    func getActivities() async -> [ActivitySummary] {
        do {
            let querySnapshot = try await db.collection("activitySummaries")
                .order(by: "startTime", descending: false)
                .getDocuments()
            
            return try querySnapshot.documents.map {
                try $0.data(as: ActivitySummary.self)
            }
        } catch {
            fetchingError = true
            return []
        }
    }
}


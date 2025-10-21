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
        let activityRef = db.collection("activities").document()
        let summaryRef = db.collection("activitySummaries").document()
        
        var activityToSave = activity // temp var since function parameters are constants (let) and cannot be modified
        activityToSave.id = activityRef.documentID
        
        let activitySummary = ActivitySummary(from: activityToSave) // creating summary to save for the activity
        
        do {
            try activityRef.setData(from: activityToSave)
            try summaryRef.setData(from: activitySummary)
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


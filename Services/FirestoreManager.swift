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
        var activityToSave = activity
        let ref = db.collection("activities").document()
        activityToSave.id = ref.documentID
        
        do {
            try ref.setData(from: activityToSave)
        } catch {
            savingError = true
        }
    }
    
    func getActivities() async -> [ActivitySummary] {
        var tempActivity: Activity
        var summaries: [ActivitySummary] = []
        
        do {
            let querySnapshot = try await db.collection("activities")
                .order(by: "startTime", descending: false)
                .getDocuments()
            
            for document in querySnapshot.documents {
                tempActivity = try document.data(as: Activity.self)
                summaries.append(createSummary(tempActivity))
            }
        } catch {
            fetchingError = true
        }
        
        return summaries
    }
    
    func createSummary(_ activity: Activity) -> ActivitySummary {
        return ActivitySummary(id: activity.id!, activityType: activity.activityType, startTime: activity.startTime, endTime: activity.endTime)
    }
}


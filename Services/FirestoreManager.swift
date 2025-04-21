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
}


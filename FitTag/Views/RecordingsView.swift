//
//  RecordingsView.swift
//  FitTag
//
//  Created by Luca Zorzi on 19/04/25.
//

import SwiftUI

struct RecordingsView: View {
    @StateObject private var firestoreManager = FirestoreManager()
    
    @State private var activitySummaries: [ActivitySummary] = []
    
    var body: some View {
        NavigationStack {
            List(activitySummaries) { activitySummary in
                ActivitySummaryView(activitySummary: activitySummary)
            }
            .navigationTitle("Your Recordings")
            .onAppear {
                Task {
                    let summaries = await firestoreManager.getActivities()
                    activitySummaries = summaries
                }
            }
            .alert("An error occurred while downloading your activities", isPresented: $firestoreManager.fetchingError) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}

#Preview {
    RecordingsView()
}

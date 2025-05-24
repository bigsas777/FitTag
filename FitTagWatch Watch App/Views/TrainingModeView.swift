//
//  TrainingModeView.swift
//  FitTagWatch Watch App
//
//  Created by Luca Zorzi on 17/05/25.
//

import SwiftUI

struct TrainingModeView: View {
    @State private var selezione: ActivityType = .standing
    @State private var startTime: Date?
    @State private var endTime: Date?
    
    @State private var buttonText = "Record activity"
    @State private var buttonColor = Color.green
    
    @State private var isRecording = false
    @State private var showSaveDialog = false
    
    @StateObject private var motionManager = MotionManager()
    
    var body: some View {
        return NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                // Picker Attività
                Picker("Select activity:", selection: $selezione) {
                    ForEach(ActivityType.allCases) { activity in
                        Text(activity.rawValue.capitalized)
                    }
                }
                .disabled(isRecording)
                
                Spacer()
                
                // Bottone di registrazione
                Button(action: toggleRecording) {
                    Text(buttonText)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.bordered)
                .tint(buttonColor)
                .clipShape(Capsule())
            }
            .padding()
            
            .confirmationDialog("Do you want to save this activity?", isPresented: $showSaveDialog) {
                
                Button("Save") {
                    saveActivity()
                }
                
                Button("Discard", role: .cancel) {
                    discardActivity()
                }
            }
            .alert("Device Motion not available", isPresented: $motionManager.sensorsUnavailable) {
                Button("OK", role: .cancel) { }
            }
        }
        
        func toggleRecording() {
            if !isRecording {
                isRecording.toggle()
                startTime = Date()
                motionManager.startUpdates()
                if motionManager.sensorsUnavailable {
                    isRecording.toggle()
                    discardActivity()
                    return // Non modifica la UI se i sensori non sono disponibili
                }
                
                buttonText = "Stop recording"
                buttonColor = .red
            } else {
                isRecording.toggle()
                motionManager.stopUpdates()
                endTime = Date()
                
                buttonText = "Record activity"
                buttonColor = .green
                showSaveDialog = true
            }
        }
        
        func saveActivity() {
            guard let safeStartTime = startTime, let safeEndTime = endTime else { return }
            
            let activityToSave = Activity(
                id: nil,
                activityType: selezione,
                startTime: safeStartTime,
                endTime: safeEndTime,
                accelerometerData: motionManager.accelerometerData,
                gyroscopeData: motionManager.gyroscopeData
            )
            
            WatchConnectivityManager.shared.sendActivity(activityToSave)
        }

        func discardActivity() {
            startTime = nil
            endTime = nil
            motionManager.resetData()
        }
    }
}

#Preview {
    TrainingModeView()
}

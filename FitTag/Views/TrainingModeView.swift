//
//  TrainingModeView.swift
//  FitTag
//
//  Created by Luca Zorzi on 19/04/25.
//

import SwiftUI

struct TrainingModeView: View {
    @State private var selection: ActivityType = .standing
    @State private var startTime: Date?
    @State private var endTime: Date?
    
    @State private var buttonText = "Record activity"
    @State private var buttonColor = Color.green
    
    @State private var isRecording = false
    @State private var showSaveDialog = false
    
    @StateObject private var motionManager = MotionManager()
    @StateObject private var firestoreManager = FirestoreManager()
    
    var startTimeStr: String {
        startTime?.formatted(date: .omitted, time: .standard) ?? "--:--:--"
    }
    
    var endTimeStr: String {
        endTime?.formatted(date: .omitted, time: .standard) ?? "--:--:--"
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                // Activity picker
                HStack {
                    Text("Activity:")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Picker("Select activity", selection: $selection) {
                        ForEach(ActivityType.allCases, id: \.self) { activity in
                            Text(activity.name).tag(activity)
                        }
                    }
                    .pickerStyle(.menu)
                    .disabled(isRecording)
                }
                
                // Times
                HStack {
                    Text("Start time:")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(startTimeStr)
                }
                
                HStack {
                    Text("End time:")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(endTimeStr)
                }
                
                Spacer()
                
                // Record button
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
            .navigationTitle("Training Mode")
            
            .confirmationDialog("Do you want to save this activity?", isPresented: $showSaveDialog) {
                
                Button("Save") {
                    saveActivity()
                }
                
                Button("Discard", role: .cancel) {
                    discardActivity()
                }
            } message: {
                Text("Do you want to save this activity?")
            }
            .alert("Sensors not available", isPresented: $motionManager.sensorsUnavailable) {
                Button("OK", role: .cancel) { }
            }
            .alert("Saving error", isPresented: $firestoreManager.savingError) {
                Button("OK", role: .cancel) { }
            }
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
            activityType: selection,
            startTime: safeStartTime,
            endTime: safeEndTime,
            accelerometerData: motionManager.accelerometerData,
            gyroscopeData: motionManager.gyroscopeData
        )
        
        firestoreManager.saveActivity(activityToSave)
        
        discardActivity()
    }

    func discardActivity() {
        startTime = nil
        endTime = nil
        motionManager.resetData()
    }
}

#Preview {
    TrainingModeView()
}

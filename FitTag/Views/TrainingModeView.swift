//
//  TrainingModeView.swift
//  FitTag
//
//  Created by Luca Zorzi on 19/04/25.
//

import SwiftUI

struct TrainingModeView: View {
    @State private var selezione: ActivityType = .standing
    @State private var startTime: Date?
    @State private var endTime: Date?
    
    @State private var buttonText = "Registra attività"
    @State private var buttonColor = Color.green
    
    @State private var isRecording = false
    @State private var showSaveDialog = false
    
    @StateObject private var motionManager = MotionManager()
    @StateObject private var firestoreManager = FirestoreManager()
    
    var startTimeStr: String {
        startTime?.formatted(date: .omitted, time: .standard) ?? "00:00:00"
    }
    
    var endTimeStr: String {
        endTime?.formatted(date: .omitted, time: .standard) ?? "00:00:00"
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                // Picker Attività
                HStack {
                    Text("Attività:")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Picker("Seleziona un'attività", selection: $selezione) {
                        ForEach(ActivityType.allCases, id: \.self) { activity in
                            Text(activity.name).tag(activity)
                        }
                    }
                    .pickerStyle(.menu)
                    .disabled(isRecording)
                }
                
                // Orari
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
            .navigationTitle("Training Mode")
            
            .confirmationDialog("Vuoi salvare questa attività?", isPresented: $showSaveDialog) {
                
                Button("Salva") {
                    saveActivity()
                }
                
                Button("Scarta", role: .cancel) {
                    discardActivity()
                }
            } message: {
                Text("Vuoi salvare questa attività?")
            }
            .alert("Sensori non disponibili", isPresented: $motionManager.sensorsUnavailable) {
                Button("OK", role: .cancel) { }
            }
            .alert("Errore nel salvataggio", isPresented: $firestoreManager.savingError) {
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
            
            buttonText = "Fine attività"
            buttonColor = .red
        } else {
            isRecording.toggle()
            motionManager.stopUpdates()
            endTime = Date()
            
            buttonText = "Registra attività"
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
        
        firestoreManager.saveActivity(activityToSave)
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

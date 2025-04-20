//
//  TrainingModeView.swift
//  FitTag
//
//  Created by Luca Zorzi on 19/04/25.
//

import SwiftUI

struct TrainingModeView: View {
    @State private var selezione: ActivityType = .running
    @State private var startTime: Date?
    @State private var endTime: Date?
    
    @State private var buttonText = "Registra attività"
    @State private var buttonColor = Color.green
    
    @State private var isRecording = false
    @State private var showSaveDialog = false
    
    let activities = ["Corsa", "Camminata", "Nuoto", "Ciclismo"]
    
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
                        .fontWeight(.bold)
                    
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
                        .fontWeight(.bold)
                    Spacer()
                    Text(startTimeStr)
                }
                
                HStack {
                    Text("End time:")
                        .font(.title2)
                        .fontWeight(.bold)
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
                
                Button("Salva in cloud") {
                    saveInCloud()
                }
                
                Button("Scarta", role: .cancel) {
                    discardActivity()
                }
            } message: {
                Text("Vuoi salvare questa attività?")
            }
        }
    }
    
    func toggleRecording() {
        isRecording.toggle()
        
        if isRecording {
            startTime = Date()
            buttonText = "Fine attività"
            buttonColor = .red
        } else {
            endTime = Date()
            buttonText = "Registra attività"
            buttonColor = .green
            showSaveDialog = true
        }
    }
    
    // Magari ste funzione le sposto in un file dedicato alla logica
    
    // TODO
    func saveActivity() {
        print("Attività salvata")
    }
    
    // TODO
    func saveInCloud() {
        print("Attività salvate in cloud")
    }

    func discardActivity() {
        startTime = nil
        endTime = nil
        // Pulire dati accelerometro e giroscopio
    }
}

#Preview {
    TrainingModeView()
}

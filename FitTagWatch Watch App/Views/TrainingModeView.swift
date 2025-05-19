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
    
    @State private var buttonText = "Registra attività"
    @State private var buttonColor = Color.green
    /*
    @State private var isRecording = false
    @State private var showSaveDialog = false
    
    @StateObject private var motionManager = MotionManager()
    @StateObject private var firestoreManager = FirestoreManager()*/

    
    // let activities = ["Corsa", "Camminata", "Nuoto", "Ciclismo"]
    
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
                Text("Attività:")
                    .fontWeight(.bold)
                
                Picker("Seleziona un'attività", selection: $selezione) {
                    ForEach(ActivityType.allCases) { activity in
                        Text(activity.rawValue.capitalized)
                    }
                }
                .pickerStyle(.wheel)
                // .disabled(isRecording)
                
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
                Button(action: {}/*toggleRecording*/) {
                    Text(buttonText)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.bordered)
                .tint(buttonColor)
                .clipShape(Capsule())
            }
            .padding()
        }
    }
}

#Preview {
    TrainingModeView()
}

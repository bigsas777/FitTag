//
//  LiveDetectionView.swift
//  FitTag
//
//  Created by Luca Zorzi on 19/04/25.
//

import SwiftUI

struct LiveDetectionView: View {
    private let recordingTimer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var outputActivity: String = "standing"
    
    @StateObject private var classificationManager = ClassificationManager()
    @StateObject private var motionManager = MotionManager()
    
    var colors: [Color] {
        switch outputActivity {
            case "running": return [.red, .orange]
            case "walking": return [.green, .yellow]
            case "swimming": return [.teal, .blue]
            case "cycling": return [.yellow, .orange]
            case "standing": return [.blue, .purple]
            default: return [.gray, .white]
        }
    }
    
    var icon: String {
        switch outputActivity {
            case "running": return "figure.run"
            case "walking": return "figure.walk"
            case "swimming": return "figure.pool.swim"
            case "cycling": return "figure.outdoor.cycle"
            case "standing": return "figure.stand"
            default: return "figure.stand"
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: colors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                        .frame(width: 200, height: 200) // Circle size

                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100) // Icon size
                        .foregroundColor(.white)
                }
                
                Text(outputActivity.capitalized)
                    .font(.title2)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .navigationTitle("Live Detection")
        }
        .onAppear {
            motionManager.startUpdates()
        }
        .onDisappear {
            motionManager.stopUpdates()
            motionManager.resetData()
        }
        .onReceive(recordingTimer) { _ in
            guard !motionManager.sensorsUnavailable else {
                motionManager.stopUpdates()
                motionManager.resetData()
                return
            }
            
            outputActivity = classificationManager.getClassification(accelData: motionManager.accelerometerData, gyroData: motionManager.gyroscopeData)

            motionManager.resetData()
        }
    }
}

#Preview {
    LiveDetectionView()
}

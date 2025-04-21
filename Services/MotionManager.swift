//
//  MotionManager.swift
//  FitTag
//
//  Created by Luca Zorzi on 21/04/25.
//

import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private let updateInterval = 0.02 // 50 Hz

    @Published var accelerometerData: [CMAccelerometerData] = []
    @Published var gyroscopeData: [CMGyroData] = []
    
    @Published var sensorsUnavailable = false

    func startUpdates() {
        guard motionManager.isAccelerometerAvailable, motionManager.isGyroAvailable else {
            sensorsUnavailable = true
            return
        }

        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.gyroUpdateInterval = updateInterval

        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            if let data = data {
                self?.accelerometerData.append(data)
            }
        }

        motionManager.startGyroUpdates(to: .main) { [weak self] data, _ in
            if let data = data {
                self?.gyroscopeData.append(data)
            }
        }
    }

    func stopUpdates() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
    }

    func resetData() {
        accelerometerData.removeAll()
        gyroscopeData.removeAll()
    }
}

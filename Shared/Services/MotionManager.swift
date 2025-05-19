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
    private let updateInterval = 0.1 // 10 Hz

    @Published var accelerometerData: [Sample] = []
    @Published var gyroscopeData: [Sample] = []
    
    @Published var sensorsUnavailable = false

    func startUpdates() {
        guard motionManager.isAccelerometerAvailable, motionManager.isGyroAvailable else {
            sensorsUnavailable = true
            return
        }

        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.gyroUpdateInterval = updateInterval

        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self = self, let data = data else { return }
            let sample = Sample(
                timeStamp: Date(),
                x: Float(data.acceleration.x),
                y: Float(data.acceleration.y),
                z: Float(data.acceleration.z)
            )
            self.accelerometerData.append(sample)
        }

        motionManager.startGyroUpdates(to: .main) { [weak self] data, _ in
            guard let self = self, let data = data else { return }
            let sample = Sample(
                timeStamp: Date(),
                x: Float(data.rotationRate.x),
                y: Float(data.rotationRate.y),
                z: Float(data.rotationRate.z)
            )
            self.gyroscopeData.append(sample)
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

//
//  MotionManager.swift
//  FitTag
//
//  Created by Luca Zorzi on 21/04/25.
//

import Foundation
import CoreMotion
import HealthKit

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private let updateInterval = 1.0 / 10.0 // 10 Hz

    @Published var accelerometerData: [Sample] = []
    @Published var gyroscopeData: [Sample] = []
    
    @Published var sensorsUnavailable = false


    func startUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            sensorsUnavailable = true
            return
        }

        motionManager.deviceMotionUpdateInterval = updateInterval
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] data, _ in
            guard let self = self, let data = data else { return }

            let sampleAccel = Sample(
                timeStamp: Date(),
                x: Float(data.userAcceleration.x),
                y: Float(data.userAcceleration.y),
                z: Float(data.userAcceleration.z)
            )
            self.accelerometerData.append(sampleAccel)

            let sampleGyro = Sample(
                timeStamp: Date(),
                x: Float(data.rotationRate.x),
                y: Float(data.rotationRate.y),
                z: Float(data.rotationRate.z)
            )
            self.gyroscopeData.append(sampleGyro)
        }
    }

    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }

    func resetData() {
        accelerometerData.removeAll()
        gyroscopeData.removeAll()
    }
}

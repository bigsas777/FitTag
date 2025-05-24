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
    
    private var timer: Timer?

    @Published var accelerometerData: [Sample] = []
    @Published var gyroscopeData: [Sample] = []
    
    @Published var sensorsUnavailable = false

    func startUpdates() {
        /*motionManager.isAccelerometerAvailable, motionManager.isGyroAvailable*/
        guard motionManager.isDeviceMotionAvailable else {
            sensorsUnavailable = true
            return
        }

        /* motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.gyroUpdateInterval = updateInterval */
        motionManager.deviceMotionUpdateInterval = updateInterval
        
        motionManager.startDeviceMotionUpdates()
        
        self.timer = Timer(fire: Date(), interval: updateInterval, repeats: true, block: {
            (tiemr) in
            if let data = self.motionManager.deviceMotion
                {
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
        })
        
        RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)

        /*motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
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
        }*/
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

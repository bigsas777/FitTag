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
    
    #if os(watchOS)
    private let healthStore: HKHealthStore?
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    #else
    private let healthStore: HKHealthStore? = nil
    private var session: HKWorkoutSession? = nil
    private var builder: HKLiveWorkoutBuilder? = nil
    #endif

    @Published var accelerometerData: [Sample] = []
    @Published var gyroscopeData: [Sample] = []
    
    @Published var sensorsUnavailable = false
    
    init() {
        #if os(watchOS)
        if HKHealthStore.isHealthDataAvailable() {
            let store = HKHealthStore()
            self.healthStore = store

            store.requestAuthorization(toShare: nil, read: nil) { success, error in
                if !success {
                    print("HealthKit authorization failed: \(error?.localizedDescription ?? "unknown error")")
                    DispatchQueue.main.async {
                        self.sensorsUnavailable = true
                    }
                }
            }
        } else {
            self.healthStore = nil
            self.sensorsUnavailable = true
        }
        #endif
    }

    func startUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            sensorsUnavailable = true
            return
        }
        
        #if os(watchOS)
        startWorkoutSession()
        #endif

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
        #if os(watchOS)
        endWorkoutSession()
        #endif
    }

    func resetData() {
        accelerometerData.removeAll()
        gyroscopeData.removeAll()
    }
    
    #if os(watchOS)
    func startWorkoutSession() {
        guard let healthStore = self.healthStore else {
                print("HealthStore not available")
                return
            }
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .walking
        configuration.locationType = .indoor
        
        do {
            let session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            let builder = session.associatedWorkoutBuilder()
            
            self.session = session
            self.builder = builder
            
            builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
            session.startActivity(with: Date())
            builder.beginCollection(withStart: Date()) { success, error in
                if !success {
                    print("Failed to start collection")
                }
            }
        } catch {
            print("Could not create workout session: \(error.localizedDescription)")
        }
    }
    
    func endWorkoutSession() {
        guard let session = session, let builder = builder else { return }
        
        session.stopActivity(with: Date())
        builder.endCollection(withEnd: Date()) { (success, error) in
            if success {
                builder.discardWorkout()
                session.end()
            } else {
                print("Failed to end collection")
            }
        }
    }
    #endif
}

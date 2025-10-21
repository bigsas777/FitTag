//
//  ActivityClassification.swift
//  FitTag
//
//  Created by Luca Zorzi on 20/10/25.
//

import Foundation

final class ClassificationManager: ObservableObject {
    private let fitTagClassifier = try? FitTag(configuration: .init())

    func getClassification(accelData: [Sample], gyroData: [Sample]) -> String {
        guard
            !accelData.isEmpty,
            !gyroData.isEmpty,
            let classifier = fitTagClassifier
        else {
            return "unknown"
        }

        // Calculating features
        let x_mean_accel = meanForAxis(data: accelData, axis: 0)
        let y_mean_accel = meanForAxis(data: accelData, axis: 1)
        let z_mean_accel = meanForAxis(data: accelData, axis: 2)

        let x_std_accel = stdForAxis(data: accelData, axis: 0)
        let y_std_accel = stdForAxis(data: accelData, axis: 1)
        let z_std_accel = stdForAxis(data: accelData, axis: 2)

        let x_mean_gyro = meanForAxis(data: gyroData, axis: 0)
        let y_mean_gyro = meanForAxis(data: gyroData, axis: 1)
        let z_mean_gyro = meanForAxis(data: gyroData, axis: 2)

        let x_std_gyro = stdForAxis(data: gyroData, axis: 0)
        let y_std_gyro = stdForAxis(data: gyroData, axis: 1)
        let z_std_gyro = stdForAxis(data: gyroData, axis: 2)

        if let prediction = try? classifier.prediction(
            x_mean_accel: x_mean_accel,
            y_mean_accel: y_mean_accel,
            z_mean_accel: z_mean_accel,
            x_std_accel: x_std_accel,
            y_std_accel: y_std_accel,
            z_std_accel: z_std_accel,
            x_mean_gyro: x_mean_gyro,
            y_mean_gyro: y_mean_gyro,
            z_mean_gyro: z_mean_gyro,
            x_std_gyro: x_std_gyro,
            y_std_gyro: y_std_gyro,
            z_std_gyro: z_std_gyro
        ) {
            return prediction.activity_type
        } else {
            return "unknown"
        }

    }

    // Extracts the values of a specific axis (x, y, or z) from an array of `Sample` objects.
    private func extractAxis(_ data: [Sample], axis: Int) -> [Double] {
        switch axis {
        case 0: return data.map { Double($0.x) }
        case 1: return data.map { Double($0.y) }
        case 2: return data.map { Double($0.z) }
        default: return []
        }
    }

    // Calculates the arithmetic mean of the specified axis values from an array of Sample objects.
    private func meanForAxis(data: [Sample], axis: Int) -> Double {
        let values = extractAxis(data, axis: axis)
        guard !values.isEmpty else { return 0.0 }
        return values.reduce(0, +) / Double(values.count)
    }

    // Calculates the standard deviation of the specified axis values from an array of Sample objects.
    private func stdForAxis(data: [Sample], axis: Int) -> Double {
        let values = extractAxis(data, axis: axis)
        guard !values.isEmpty else { return 0.0 }
        let mean = values.reduce(0, +) / Double(values.count)
        let variance = values.reduce(0) { $0 + pow($1 - mean, 2) } / Double(values.count)
        return sqrt(variance)
    }
}

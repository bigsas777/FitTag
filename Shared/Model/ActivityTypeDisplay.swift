//
//  ActivityTypeDisplay.swift
//  FitTag
//
//  Created by Luca Zorzi on 20/04/25.
//

import Foundation

extension ActivityType {
    var name: String {
        switch self {
        case .running: return "Running"
        case .walking: return "Walking"
        case .swimming: return "Swimming"
        case .cycling: return "Cycling"
        case .standing: return "Standing"
        }
    }
}

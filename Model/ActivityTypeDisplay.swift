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
        case .running: return "Corsa"
        case .walking: return "Camminata"
        case .swimming: return "Nuoto"
        case .cycling: return "Ciclismo"
        }
    }
}

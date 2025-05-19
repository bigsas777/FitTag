//
//  ActivityType.swift
//  FitTag
//
//  Created by Luca Zorzi on 20/04/25.
//

import Foundation

enum ActivityType: String, Identifiable, Codable, CaseIterable, Hashable {
    case running, walking, swimming, cycling, standing
    
    var id: Self { self }
}

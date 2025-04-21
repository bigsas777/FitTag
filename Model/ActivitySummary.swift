//
//  ActivitySummary.swift
//  FitTag
//
//  Created by Luca Zorzi on 21/04/25.
//

import Foundation

struct ActivitySummary: Hashable, Codable, Identifiable {
    var id: String
    var activityType: ActivityType
    var startTime: Date
    var endTime: Date
}

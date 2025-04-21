//
//  Activity.swift
//  FitTag
//
//  Created by Luca Zorzi on 20/04/25.
//

import Foundation

struct Activity: Hashable, Codable, Identifiable {
    var id: String?
    var activityType: ActivityType
    var startTime: Date
    var endTime: Date
    var accelerometerData: [Sample]
    var gyroscopeData: [Sample]
}

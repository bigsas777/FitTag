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

extension ActivitySummary {
    init(from activity: Activity) {
        self.id = activity.id ?? UUID().uuidString
        self.activityType = activity.activityType
        self.startTime = activity.startTime
        self.endTime = activity.endTime
    }
}

//
//  ActivitySummaryView.swift
//  FitTag
//
//  Created by Luca Zorzi on 21/04/25.
//

import SwiftUI

struct ActivitySummaryView: View {
    var activitySummary: ActivitySummary
    
    var colors: [Color] {
        switch activitySummary.activityType {
            case .running: return [.red, .orange]
            case .walking: return [.green, .yellow]
            case .swimming: return [.teal, .blue]
            case .cycling: return [.yellow, .orange]
            case .standing: return [.blue, .purple]
        }
    }
    
    var icon: String {
        switch activitySummary.activityType {
            case .running: return "figure.run"
            case .walking: return "figure.walk"
            case .swimming: return "figure.pool.swim"
            case .cycling: return "figure.outdoor.cycle"
            case .standing: return "figure.stand"
        }
    }
    
    var durationStr: String {
        let duration = activitySummary.endTime.timeIntervalSince(activitySummary.startTime)
        
        if duration < 60 {
            // Mostra solo i secondi
            let seconds = Int(duration)
            return "\(seconds) sec"
        } else {
            // Mostra mm:ss
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = [.pad]
            let formatted = formatter.string(from: duration) ?? "00:00"
            return "\(formatted) min"
        }
    }
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)

                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                // Titolo attività
                Text(activitySummary.activityType.name)
                    .font(.headline)
                    .fontWeight(.bold)

                // Info dettagliate
                HStack(spacing: 15) {
                    HStack(spacing: 5) {
                        Image(systemName: "clock")
                        Text(activitySummary.startTime.formatted(date: .omitted, time: .standard))
                    }
                    .font(.caption)
                    .foregroundColor(.gray)

                    HStack(spacing: 5) {
                        Image(systemName: "timer")
                        Text("\(durationStr)")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
            }

            Spacer()
        }
    }
}

#Preview {
    ActivitySummaryView(activitySummary: ActivitySummary(id: "Sus", activityType: ActivityType.standing, startTime: Date(), endTime: Date() + 1265))
}

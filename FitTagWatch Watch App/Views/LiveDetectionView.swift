//
//  LiveDetectionView.swift
//  FitTagWatch Watch App
//
//  Created by Luca Zorzi on 17/05/25.
//

import SwiftUI

struct LiveDetectionView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                                colors: [.teal, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                        .frame(width: 140, height: 140) // Grandezza del cerchio

                    Image(systemName: "figure.pool.swim")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70) // Grandezza dell'icona
                        .foregroundColor(.white)
                }
                
                Text("Swimming")
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

#Preview {
    LiveDetectionView()
}

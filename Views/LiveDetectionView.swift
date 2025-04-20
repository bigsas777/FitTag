//
//  LiveDetectionView.swift
//  FitTag
//
//  Created by Luca Zorzi on 19/04/25.
//

import SwiftUI

struct LiveDetectionView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                                colors: [.teal, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                        .frame(width: 200, height: 200) // Grandezza del cerchio

                    Image(systemName: "figure.pool.swim")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100) // Grandezza dell'icona
                        .foregroundColor(.white)
                }
                
                Text("Recognized activity: Swimming")
                    .font(.title2)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .navigationTitle("Live Detection")
        }
    }
}

#Preview {
    LiveDetectionView()
}

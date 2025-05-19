//
//  ContentView.swift
//  FitTag
//
//  Created by Luca Zorzi on 19/04/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .TrainingMode
    
    enum Tab {
        case TrainingMode
        case LiveDetection
        case Recordings
    }
    
    var body: some View {
        TabView(selection: $selection) {
            TrainingModeView()
                .tabItem {
                    Label("Training Mode", systemImage: "plus")
                }
                .tag(Tab.TrainingMode)
            
            LiveDetectionView()
                .tabItem {
                    Label("Live Detection", systemImage: "figure.run")
                }
                .tag(Tab.LiveDetection)
            
            RecordingsView()
                .tabItem {
                    Label("Recordings", systemImage: "tray.full")
                }
                .tag(Tab.Recordings)
        }
    }
}

#Preview {
    ContentView()
}

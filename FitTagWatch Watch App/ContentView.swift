//
//  ContentView.swift
//  FitTagWatch Watch App
//
//  Created by Luca Zorzi on 17/05/25.
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
                .tag(Tab.TrainingMode)
            
            LiveDetectionView()
                .tag(Tab.LiveDetection)
            
            RecordingsView()
                .tag(Tab.Recordings)
        }
    }
}

#Preview {
    ContentView()
}

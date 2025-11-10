//
//  GPSDataCollection.swift
//  MetroGnome
//
//  Created by Connor Kale on 11/10/25.
//

import SwiftUI

struct GPSDataCollection: View {
    var body: some View {
        TabView {
            GPSDataDisplay()
                .tabItem {
                    Label("Collected Data", systemImage: "waveform.path.ecg.text.clipboard")
                }
            
            GPSDataCollecter()
                .tabItem {
                    Label("Take Point", systemImage: "figure.walk.motion")
                }

        }
    }
}

#Preview {
    GPSDataCollection()
}

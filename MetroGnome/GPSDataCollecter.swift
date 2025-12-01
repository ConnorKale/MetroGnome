//
//  GPSDataCollecter.swift
//  MetroGnome
//
//  Created by Connor Kale on 11/10/25.
//

import SwiftUI

struct GPSDataCollecter: View {
    
    @Binding var isCollectingData: Bool
    @Binding var CollectionNeedsToStop: Bool
    
    @Binding public var tonePlayerMode: Int

    private var backgroundColor: Color {
        switch isCollectingData {
        case false:
            return Color(red: (67.0/255.0), green: (0.0/255.0), blue: (0.0/255.0))
        default:
            return Color(red: (255.0/255.0), green: (0.0/255.0), blue: (0.0/255.0))
        }
    }

    var body: some View {
        ScrollView {
            Button(isCollectingData ? "Stop" : "Start") {
                if isCollectingData {
                    // stop
                    CollectionNeedsToStop = true // This script asks the Collection to stop nicely but doesn't actually do anything
                    tonePlayerMode = 5 // need to decend
                } else {
                    // start
                    isCollectingData = true
                    tonePlayerMode = 1 // need to ascend
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(.system(size: 300))
        }
        .background(backgroundColor)
    }
}

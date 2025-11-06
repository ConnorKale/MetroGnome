//
//  GyroScopeUI.swift
//  MetroGnome
//
//  Created by Connor Kale on 11/6/25.
//

import SwiftUI

struct GyroScopeUI: View {
    @ObservedObject var theMotionManager: MotionManager
    
    @Binding var radius: Double // I think 0.5 is around average.
    @Binding var TonePlayerIsPlaying: Bool
    @Binding var tonePlayer: TonePlayer
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Gyroscope Data:")
                .font(.system(size: 50))
            Text("x: \(theMotionManager.gyroscopeData.x, specifier: "%.2f")")
            Text("y: \(theMotionManager.gyroscopeData.y, specifier: "%.2f")")
            Text("z: \(theMotionManager.gyroscopeData.z, specifier: "%.2f")")
            
            Text("Total: \(theMotionManager.gyroscopeData.total, specifier: "%.2f")")
                .font(.system(size: 67)) // :)
            
            Text("R: \(radius, specifier: "%.2f")")
                .font(.system(size: 67)) // :)
            
            Button(TonePlayerIsPlaying ? "Stop" : "Play") {
                if TonePlayerIsPlaying {
                    tonePlayer.stop()
                    TonePlayerIsPlaying = false
                } else {
                    tonePlayer.start()
                    TonePlayerIsPlaying = true
                }
            }
            .font(.system(size: 100))
            
        }
    }
}

#Preview {
    TabBarController()
}

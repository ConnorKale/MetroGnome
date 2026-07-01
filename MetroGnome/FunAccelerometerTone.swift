//
//  FunAccelerometerTone.swift
//  MetroGnome
//
//  Created by Connor Kale on 6/30/26.
//

import SwiftUI

struct FunAccelerometerTone: View {
    @Binding var tonePlayer: TonePlayer
    @ObservedObject var motionManager: MotionManager
    
    @State public var basePitch: Double = 0 // This is what plays if you're at 1 g
    
    var body: some View {
        ScrollView {
            Text("This is REALLY old lol, from sophomore year")
            
            Button("Off")
            {
                basePitch = 0
                tonePlayer.stop()
            }
            .font(.system(size: 40))

                   
            Button("Base to 55")
            {
                basePitch = 55
                tonePlayer.start()
            }
            .font(.system(size: 40))

            Button("Base to 110")
            {
                basePitch = 110
                tonePlayer.start()
            }
            .font(.system(size: 40))
            
            Button("Base to 220")
            {
                basePitch = 220
                tonePlayer.start()
            }
            .font(.system(size: 40))
            
            Button("Base to 440")
            {
                basePitch = 440
                tonePlayer.start()
            }
            .font(.system(size: 40))

            Button("Base to 880")
            {
                basePitch = 880
                tonePlayer.start()
            }
            .font(.system(size: 40))

            Text("\(motionManager.accelerometerData.total, specifier: "%.3f")g")
                .font(.system(size: 80))
            Text("\(basePitch * motionManager.accelerometerData.total, specifier: "%.3f") Hz")
                .font(.system(size: 80))
        }
        .onChange(of: motionManager.accelerometerData.total) { newTotal in
            // Update the pitch based on accelerometer data (total magnitude)
            tonePlayer.setFrequency(basePitch * newTotal)
        }
    }
}
/*
#Preview {
    FunAccelerometerTone()
}
*/

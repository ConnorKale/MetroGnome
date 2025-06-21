//
//  ContentView.swift
//  MetroGnome
//
//  Created by Connor Kale on 4/24/25.
//

import Combine
import SwiftUI


struct ContentView: View {
    @StateObject private var motionManager = MotionManager()
    let tonePlayer1 = TonePlayer() //A3
    let tonePlayer2 = TonePlayer() //C3
    let tonePlayer3 = TonePlayer() //F3
    let tonePlayer4 = TonePlayer() //A4
    let tonePlayer5 = TonePlayer() //C4
    let tonePlayer6 = TonePlayer() //F4
    let tonePlayer7 = TonePlayer() //A5
    @State private var chordNote: Int = 1

    private let lowAccelermomerWaterMark: Double = 1.5
    private let highAcceleromerWaterMark: Double = 3.0

    private let lowJerkWaterMark: Double = -5.0
    private let highJerkWaterMark: Double = 10.0
    
    @State private var startTime: Date?
    @State private var endTime: Date?
    @State private var elapsedTime: TimeInterval?
    @State private var lastStrideTime: Double = 0.0
    @State private var secondLastStrideTime: Double = 0.0
    @State private var thirdLastStrideTime: Double = 0.0
    @State private var fourthLastStrideTime: Double = 0.0
    @State private var averageLastStrideTime: Double = 0.0

    @State private var lookingForAboveHigh: Bool = true
    @State private var major: Bool = true
/*
    private var backgroundColor: Color {
        switch motionManager.accelerometerData.total {
        case ..<lowAccelermomerWaterMark:
            return Color(red: 0.0, green: 1.0, blue: 0.0) // Green
        case lowAccelermomerWaterMark...highAcceleromerWaterMark:
            return Color(red: 1.0, green: 0.0, blue: 0.0) // Red
        default:
            return Color(red: 0.0, green: 0.0, blue: 1.0) // Blue
        }
    }
    */
    private var backgroundColor: Color {
        switch motionManager.accelerometerData.absoluteJerk {
        case ..<lowJerkWaterMark:
            return Color(red: 1.0, green: 0.0, blue: 0.0) // Red
        case lowJerkWaterMark...highJerkWaterMark:
            return Color(red: 0.0, green: 1.0, blue: 0.0) // Green
        default:
            return Color(red: 0.0, green: 0.0, blue: 1.0) // Blue
        }
    }

    
    var body: some View {
        
        VStack {
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .padding(.bottom, 30)
            
            Text("Accelerometer Data:")
                .font(.headline)
            Text("X: \(motionManager.accelerometerData.x, specifier: "%.2f")")
            Text("Y: \(motionManager.accelerometerData.y, specifier: "%.2f")")
            Text("Z: \(motionManager.accelerometerData.z, specifier: "%.2f")")
                .padding(.bottom, 30)
            /*Text("Pitch: \(tonePitch, specifier: "%.2f")")
                .font(.headline)
                .padding(.bottom, 50)
            */
            Text("Total:")
                .font(.system(size: 20))
            Text("\(motionManager.accelerometerData.total, specifier: "%.2f")")
            //.padding()
                .font(.system(size: 80))
                .padding(.bottom, 20)

            /*Text("Rotational dx/dt:")
                .font(.system(size: 20))
            Text("\(motionManager.accelerometerData.rotationalJerk, specifier: "%.2f")")
            //.padding()
                .font(.system(size: 80))
                .padding(.bottom, 20)*/

            Text("Absolute dx/dt:")
                .font(.system(size: 20))
            Text("\(motionManager.accelerometerData.absoluteJerk, specifier: "%.2f")")
            //.padding()
                .font(.system(size: 80))
            
            Text("Last stride (s):")
                .font(.system(size: 20))
            Text("\(lastStrideTime, specifier: "%.2f")")
            //.padding()
                .font(.system(size: 80))

            Text("Average of last four (s):")
                .font(.system(size: 20))
            Text("\(averageLastStrideTime, specifier: "%.2f")")
            //.padding()
                .font(.system(size: 80))

            Image(systemName: "waveform")
                .font(.system(size: 50))
                .foregroundStyle(.tint)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor) // Set background color based on accelerometer data
        .onAppear {
            //motionManager.startUpdates()
            
            
            tonePlayer1.start()
            tonePlayer1.setFrequency(220)
            tonePlayer2.start()
            tonePlayer2.setFrequency(0)
            tonePlayer3.start()
            tonePlayer3.setFrequency(0)
            tonePlayer4.start()
            tonePlayer4.setFrequency(440)
            tonePlayer5.start()
            tonePlayer5.setFrequency(0)
            tonePlayer6.start()
            tonePlayer6.setFrequency(0)
            tonePlayer7.start()
            tonePlayer7.setFrequency(825)




        }
        .onDisappear {
            //motionManager.stopUpdates()
            tonePlayer1.stop()
            tonePlayer2.stop()
            tonePlayer3.stop()
            tonePlayer4.stop()
            tonePlayer5.stop()
            tonePlayer6.stop()
            tonePlayer7.stop()

        }
        .onChange(of: motionManager.accelerometerData.total) { newValue in
        // Change the note
            
        chordNote += 1
        if (chordNote > 16) {
            chordNote = 1
        }

            /*switch chordNote {
            case 1:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            case 2:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            case 3:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            case 4:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            case 5:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            case 6:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
           case 7:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            case 8:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            case 9:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            case 10:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            case 11:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            case 12:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            case 13:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            case 14:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            case 15:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            default:
                tonePlayer.shutUp()
                tonePlayer.setNote(1, frequency: 220, volume: 1)
            }*/

        } // Major third is 5:4, minor third is 6:5, fifth is 3:2 or 6:4
        
        .onChange(of: motionManager.accelerometerData.absoluteJerk) { newValue in
            if ((lookingForAboveHigh) && (newValue >= highJerkWaterMark)) { // If looking for above highmark and it's above highmark
                lookingForAboveHigh = false // Move into if statement?

                if let start = startTime {
                    endTime = Date()
                    elapsedTime = endTime?.timeIntervalSince(start)
                } else {
                    elapsedTime = nil
                }
                
                if let elapsed = elapsedTime {
                    if ((elapsed >= (averageLastStrideTime/2.0)) || elapsed > 0.3) { // "or" in Swift is ||
                        // Old forthStride's data gets forgotten
                        fourthLastStrideTime = thirdLastStrideTime
                        thirdLastStrideTime = secondLastStrideTime
                        secondLastStrideTime = lastStrideTime
                        lastStrideTime = elapsed
                        
                        averageLastStrideTime = (fourthLastStrideTime + thirdLastStrideTime + secondLastStrideTime + lastStrideTime)/4.0 // Find a new average BPM

                        major = !major // Make a noticable change in the pitch for the user.

                    }
                    
                    
                }

                startTime = Date()
            }
            
            if ((!lookingForAboveHigh) && (newValue <= lowJerkWaterMark)) {// If looking for below lowmark and it's below lowmark {
                lookingForAboveHigh = true
            }
        }

    }
}


#Preview {
    ContentView()
}

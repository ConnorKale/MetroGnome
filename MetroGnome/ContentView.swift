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
    @StateObject private var audioPlayer = VariableSpeedAudioPlayer()

    //@State private var sliderValue: Double = 1.0

    private var fileTempo: Float = 180.0 // This needs to be manually changed when a new file is added.
    
    private let lowAccelermomerWaterMark: Double = 1.5
    private let highAcceleromerWaterMark: Double = 3.0

    @State private var lowJerkWaterMark: Double = -4.0
    @State private var lowJerkWaterMarkIsNegative4: Bool = true
    @State private var highJerkWaterMark: Double = 4.0
    @State private var highJerkWaterMarkIs4: Bool = true
    @State private var lookingForAboveHigh: Bool = true

    @State private var startTime: Date?
    @State private var endTime: Date?
    @State private var elapsedTime: TimeInterval?

    @State private var lastStrideTime: Double = 0.0 // In seconds
    @State private var secondLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var thirdLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var fourthLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var averageLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var tempo: Float = 180.0 // In seconds

    @State private var maxTempo: Double = 190.0 // Maybe change this back to 240? Or not, 210 is a really fast pace to run at but in theory it's possible.
    @State private var minTempo: Double = 120
    @State private var minTempoIs120: Bool = true
    @State private var maxTempoIs210: Bool = false

    private var backgroundColor: Color {
        switch motionManager.accelerometerData.jerk {
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
            VStack(spacing: 20) {
                Button(audioPlayer.isPlaying ? "Stop" : "Play") {
                    if audioPlayer.isPlaying {
                        audioPlayer.stop()
                    } else {
                        audioPlayer.loadAndPlay(filename: "MetroGnomeTestAudio_256Measures") // your .wav file name
                    }
                }
                .font(.system(size: 160))

                /*VStack {
                    Text("Playback Speed: \(String(format: "%.2f", audioPlayer.rate))x")
                    Slider(value: $sliderValue, in: 0.5...2.0, step: 0.05)
                        .padding(.horizontal)
                }*/
            }
            Text("Tempo:")
                .font(.system(size: 20))
            Text("\(tempo, specifier: "%.2f")")
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

            HStack{
                Button(minTempoIs120 ? "Min's 120" : "Min's 150") {
                    if minTempoIs120 {
                        minTempo = 150
                        minTempoIs120 = false
                    } else {
                        minTempo = 120
                        minTempoIs120 = true
                    }
                }
                .font(.system(size: 40))

                Button(maxTempoIs210 ? "Max's 210" : "Max's 190") {
                    if maxTempoIs210 {
                        maxTempo = 190
                        maxTempoIs210 = false
                    } else {
                        maxTempo = 210
                        maxTempoIs210 = true
                    }
                }
                .font(.system(size: 40))

            }
            
            HStack{
                Button(lowJerkWaterMarkIsNegative4 ? "LWM's -4" : "LWM's -10") {
                    if lowJerkWaterMarkIsNegative4 {
                        lowJerkWaterMark = -10
                        lowJerkWaterMarkIsNegative4 = false
                    } else {
                        lowJerkWaterMark = -4
                        lowJerkWaterMarkIsNegative4 = true
                    }
                }
                .font(.system(size: 40))

                Button(highJerkWaterMarkIs4 ? "HWM's 4" : "HWM's 10") {
                    if highJerkWaterMarkIs4 {
                        highJerkWaterMark = 10
                        highJerkWaterMarkIs4 = false
                    } else {
                        highJerkWaterMark = 4
                        highJerkWaterMarkIs4 = true
                    }
                }
                .font(.system(size: 40))

            }

            /*Image(systemName: "waveform")
                .font(.system(size: 50))
                .foregroundStyle(.tint)
             */
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor) // Set background color based on accelerometer data
        .onAppear {
            //motionManager.startUpdates()
        }
        .onDisappear {
            //motionManager.stopUpdates()
        }
        .onChange(of: motionManager.accelerometerData.jerk) { newValue in
            if ((lookingForAboveHigh) && (newValue >= highJerkWaterMark)) { // If looking for above highmark and it's above highmark
                lookingForAboveHigh = false // Move into if statement?

                if let start = startTime {
                    endTime = Date()
                    elapsedTime = endTime?.timeIntervalSince(start)
                } else {
                    elapsedTime = nil
                }
                
                if let elapsed = elapsedTime {
                        // Old forthStride's data gets forgotten
                        fourthLastStrideTime = thirdLastStrideTime
                        thirdLastStrideTime = secondLastStrideTime
                        secondLastStrideTime = lastStrideTime
                    lastStrideTime = min((1/(minTempo/60.0)), (max((1/(maxTempo/60.0)), elapsed)))
                        
                    averageLastStrideTime = ((fourthLastStrideTime + thirdLastStrideTime + secondLastStrideTime + lastStrideTime)/4.0) // Find a new average BPM. Forces the tempo to be between 120 and 240 BPM. Sometime might make this a user-adjustable parameter.
                    
                    tempo = 60.0/Float(averageLastStrideTime)
                    audioPlayer.rate = tempo/fileTempo

                        //changeNote() // This changes the chord note.
                }

                startTime = Date() // Is the time when the last stride happened.
            } else if ((!lookingForAboveHigh) && (newValue <= lowJerkWaterMark)) {// If looking for below lowmark and it's below lowmark {
                if let start = startTime {
                    endTime = Date()
                    elapsedTime = endTime?.timeIntervalSince(start)
                } else {
                    elapsedTime = nil
                }

                if let elapsed = elapsedTime {
                    if (elapsed > averageLastStrideTime * 0.75)
                    {
                        lookingForAboveHigh = true
                    }
                }
            }
        }

    }
    
    func changeNote() {
        // Make a noticable change in the pitch for the user.
        // Change the note
                
    }
}


#Preview {
    ContentView()
}

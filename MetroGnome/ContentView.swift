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
    
    //private let lowAccelermomerWaterMark: Double = 1.5
    //private let highAcceleromerWaterMark: Double = 3.0

    @State private var lowJerkWaterMark: Double = -4.0
    //@State private var lowJerkWaterMarkIsNegative4: Bool = true
    @State private var highJerkWaterMark: Double = 4.0
    //@State private var highJerkWaterMarkIs4: Bool = true
    //@State private var lookingForAboveHigh: Bool = true

    //@State private var startTime: Date?
    //@State private var endTime: Date?
    //@State private var elapsedTime: TimeInterval?
    
    @State private var currentAccelerationRecord: Double = 0.0
    @State private var timeOfLastAccelerationRecord: Date? = Date()
    @State private var timeOfLastTempoCalculation: Date? = Date()

    @State private var lastStrideTime: Double = 0.0 // In seconds
    @State private var secondLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var thirdLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var fourthLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var averageLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var tempo: Float = 180.0 // In seconds

    @State private var maxTempo: Double = 190.0 // Maybe change this back to 240? Or not, 210 is a really fast pace to run at but in theory it's possible.
    @State private var minTempo: Double = 120
    //@State private var minTempoIs120: Bool = true
    //@State private var maxTempoIs210: Bool = false

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
                .padding(.bottom, 30)

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
                .padding(.bottom, 30)

            HStack{
                /*Button(minTempoIs120 ? "Min's 120" : "Min's 150") {
                    if minTempoIs120 {
                        minTempo = 150
                        minTempoIs120 = false
                    } else {
                        minTempo = 120
                        minTempoIs120 = true
                    }
                }
                .font(.system(size: 40))

                Text("Test text \(lastStrideTime)")
                Button("Test String") {
                    minTempo = 200
                    // Some code runs
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
                .font(.system(size: 40))*/
                VStack { // minTempo Stuffs
                    Text("Min's \(Int(minTempo))")
                    
                    Button("Min 100") {
                        minTempo = 100
                    }
                    .font(.system(size: 40))

                    Button("Min 120") {
                        minTempo = 120
                    }
                    .font(.system(size: 40))

                    Button("Min 140") {
                        minTempo = 140
                    }
                    .font(.system(size: 40))

                    Button("Min 160") {
                        minTempo = 160
                    }
                    .font(.system(size: 40))

                    Button("Min 180") {
                        minTempo = 180
                    }
                    .font(.system(size: 40))

                }
                .padding(.horizontal, 20)
                VStack { // maxTempo Stuffs
                    Text("Max's \(Int(maxTempo))")

                    Button("Max 150") {
                        maxTempo = 150
                    }
                    .font(.system(size: 40))

                    Button("Max 170") {
                        maxTempo = 170
                    }
                    .font(.system(size: 40))

                    Button("Max 190") {
                        maxTempo = 190
                    }
                    .font(.system(size: 40))
                    Button("Max 210") {
                        maxTempo = 210
                    }
                    .font(.system(size: 40))

                    Button("Max 240") {
                        maxTempo = 240
                    }
                    .font(.system(size: 40))

                }
                .padding(.horizontal, 17)

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
        .onChange(of: motionManager.accelerometerData.jerk) { //newValue in
            // I want this script to run every frame. There might be some easy way to do this, not sure. There's definitely a "correct" way to do this that I'm not doing. Whatever, it's fine. I'll fix it later.
            
            let lastRecord: Date = timeOfLastAccelerationRecord ?? Date() // I don't understand date-related variable types but I think this is converting timeOfLastAccelerationRecord which is a Date? into a Date or the current Date if there's an error so it doesn't crash.
            let lastCalculation: Date = timeOfLastTempoCalculation ?? Date()
            
            // Lot's of date stuff involves weird question markes. Maybe a metaphor for me bing confused about it. lol
            
            let currentTime = Date()
            
            let elapsedRecordTimeInterval = currentTime.timeIntervalSince(lastRecord)
            let elapsedCalculationTimeInterval = currentTime.timeIntervalSince(lastCalculation)
            
            let elapsedRecordDouble: Double = Double(elapsedRecordTimeInterval)
            let elapsedCalculationDouble: Double = Double(elapsedCalculationTimeInterval)
            
            if ((motionManager.accelerometerData.total < currentAccelerationRecord) && elapsedRecordDouble < 0.75*averageLastStrideTime) { // If we're setting a record and it's been less that 3/4 of a stride time since the previous stride, so this is the current stride.
                // We're setting a record.
                currentAccelerationRecord = motionManager.accelerometerData.total
                timeOfLastAccelerationRecord = Date()
            }
                
            if (elapsedRecordDouble > Double(0.75*averageLastStrideTime)) {
                
                // Old forthStride's data gets forgotten
                //fourthLastStrideTime = thirdLastStrideTime
                thirdLastStrideTime = secondLastStrideTime
                secondLastStrideTime = lastStrideTime
                lastStrideTime = min((1/(minTempo/60.0)), (max((1/(maxTempo/60.0)), elapsedCalculationDouble)))
                
                averageLastStrideTime = ((thirdLastStrideTime + secondLastStrideTime + lastStrideTime)/3.0)
                tempo = 60.0/Float(averageLastStrideTime)
                
                audioPlayer.rate = tempo/fileTempo
                timeOfLastTempoCalculation = Date()
                
                // Set a record since it's the next stride.
                currentAccelerationRecord = motionManager.accelerometerData.total
                timeOfLastAccelerationRecord = Date()

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

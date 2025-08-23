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

    @State private var timer = Timer.publish(every: 1.0 / 30.0, on: .main, in: .common).autoconnect()

    //@State private var sliderValue: Double = 1.0

    private var numberOfSongs: Int = 4
    @State private var selectedSongIndex: Double = 0
    private var songNames: [String] = ["MetroGnomeTestAudio_256Measures", "MetroGnomeTestAudio_256Measures", "WikipediaCanon160BPM", "WikipediaCanon160BPM"]
    private var fileTempos: [Float] = [180.0, 90.0, 80.0, 160.0] // This needs to be manually changed when a new file is added.
    // THIS ONLY TAKES WAV FILES!!! Dad thinks imbedding FFmpeg inside the MetroGnome might be doable and might be a good idea for file-size reasons.
    @State private var currentlyPlayingFileTempo: Float = 180.0
    
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

    @State private var maxTempo: Double = 190.0
    @State private var minTempo: Double = 120
    @State private var lowestMinTempo: Double = 120.0
    @State private var highestMinTempo: Double = 190.0
    @State private var lowestMaxTempo: Double = 150.0
    @State private var highestMaxTempo: Double = 220.0

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
                        currentlyPlayingFileTempo = fileTempos[Int(selectedSongIndex)]
                        audioPlayer.loadAndPlay(filename: songNames[Int(selectedSongIndex)]) // your .wav file name
                    }
                }
                .font(.system(size: 160))
                //.padding(.bottom, 30)

                HStack {
                    Button("Prev")
                    {
                        selectedSongIndex = max(selectedSongIndex - 1, 0)
                    }
                    .font(.system(size: 24))
                    Text("Will play song number \(String(Int(selectedSongIndex + 1.0))).")
                    Button("Next")
                    {
                        selectedSongIndex = min(selectedSongIndex + 1, Double(numberOfSongs - 1))
                    }
                    .font(.system(size: 24))

                }
                Slider(value: $selectedSongIndex, in: 0...Double(numberOfSongs - 1), step: 1)
                        .padding(.horizontal)
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
            
            HStack {
                Button("-10")
                {
                    minTempo = max(minTempo - 10, lowestMinTempo)
                }
                .font(.system(size: 40))
                Text("minTempo is \(String(Int(minTempo))).")
                Button("+10")
                {
                    minTempo = min(minTempo + 10, highestMinTempo)
                }
                .font(.system(size: 40))
            }
            Slider(value: $minTempo, in: lowestMinTempo...highestMinTempo, step: 10)
                .padding(.horizontal)
                .padding(.bottom, 30)
                
                
            HStack {
                Button("-10")
                {
                    maxTempo = max(maxTempo - 10, lowestMaxTempo)
                }
                .font(.system(size: 40))

                Text("maxTempo is \(String(Int(maxTempo))).")
                Button("+10")
                {
                    maxTempo = min(maxTempo + 10, highestMaxTempo)
                }
                .font(.system(size: 40))
            }
            Slider(value: $maxTempo, in: lowestMaxTempo...highestMaxTempo, step: 10)
                    .padding(.horizontal)

            

            /*Image(systemName: "waveform")
                .font(.system(size: 50))
                .foregroundStyle(.tint)
             */
        }
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor) // Set background color based on accelerometer data
        .onAppear {
            //motionManager.startUpdates()
        }
        .onDisappear {
            //motionManager.stopUpdates()
        }
        //.onChange(of: motionManager.accelerometerData.jerk) { //newValue in
        .onReceive(timer) { _ in // This runs at 30 FPS. That can be changed in the timer variable declaration at the top.
            
            let lastRecord: Date = timeOfLastAccelerationRecord ?? Date() // I don't understand date-related variable types but I think this is converting timeOfLastAccelerationRecord which is a Date? into a Date or the current Date if there's an error so it doesn't crash.
            let lastCalculation: Date = timeOfLastTempoCalculation ?? Date()
            
            // Lot's of date stuff involves weird question markes. Maybe a metaphor for me being confused about it. lol
            
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
                
                audioPlayer.rate = tempo / currentlyPlayingFileTempo
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

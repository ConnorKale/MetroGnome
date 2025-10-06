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
    @StateObject private var GPS = LocationManager()

    private let framerate: Double = (1.0/30.0)
    @State private var timer = Timer.publish(every: 1.0 / 30.0, on: .main, in: .common).autoconnect()

    //@State private var sliderValue: Double = 1.0

    private var numberOfSongs: Int = 4
    @State private var selectedSongIndex: Int = 0
    private var songNames: [String] = ["MetroGnomeTestAudio_256Measures", "MetroGnomeTestAudio_256Measures", "WikipediaCanon160BPM", "WikipediaCanon160BPM"]
    private var fileTempos: [Float] = [180.0, 90.0, 80.0, 160.0] // This needs to be manually changed when a new file is added.
    // THIS ONLY TAKES WAV FILES!!! Dad thinks imbedding FFmpeg inside the MetroGnome might be doable and might be a good idea for file-size reasons.
    @State private var currentlyPlayingFileTempo: Float = 180.0
    
    //private let lowAccelermomerWaterMark: Double = 1.5
    //private let highAcceleromerWaterMark: Double = 3.0
    //@State private var lowJerkWaterMark: Double = -4.0
    //@State private var lowJerkWaterMarkIsNegative4: Bool = true
    //@State private var highJerkWaterMark: Double = 4.0
    //@State private var highJerkWaterMarkIs4: Bool = true
    //@State private var lookingForAboveHigh: Bool = true

    //@State private var startTime: Date?
    //@State private var endTime: Date?
    //@State private var elapsedTime: TimeInterval?
    
    @State private var rawDistanceIntegral: Double = 0.0
    @State private var smoothedDistanceIntegral: Double = 0.0
    private let velocity3: Double = 10.43841336 // This is about Usain Bolt pace, in meters per second
    @State private var usedVelocity: Int = 1 // This is what velocity algorithm you're using and should be an ∈ of {1, 2, 3}.
    @State private var goalPace: Double = 8.0 // This is in minutes per mile
    @State private var goalVelocity: Double = 3.333333338 // replace with 26.6666667/8
    @State private var lowestGoalPace: Double = 3.0
    @State private var highestGoalPace: Double = 15.0
    @State private var matchingGoalPace: Bool = true
    
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

    private var backgroundColor: Color = Color(red: (57.0/256.0), green: (15.0/256.0), blue: (87.0/256.0)) // Purple // No more epilepsy
    
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
                .font(.system(size: 100))
                .padding(.bottom, -30)

                HStack {
                    Button("Prev")
                    {
                        selectedSongIndex = max(selectedSongIndex - 1, 0)
                    }
                    .font(.system(size: 24))
                    Text("Will play song number \(String(selectedSongIndex + 1)).")
                    Button("Next")
                    {
                        selectedSongIndex = min((selectedSongIndex + 1), (numberOfSongs - 1))
                    }
                    .font(.system(size: 24))

                }
                Slider(
                    value: Binding(
                        get: { Double(selectedSongIndex) },
                        set: { selectedSongIndex = Int($0) }
                    ),
                    in: 0...Double(numberOfSongs - 1),
                    step: 1
                )
                .padding(.horizontal)
                .padding(.bottom, -20)

            }
            Text("Tempo:")
                .font(.system(size: 20))
            Text("\(tempo, specifier: "%.2f")")
                .font(.system(size: 80))
                .padding(.bottom, -20)
            
            HStack { // Which Velocity
                Text("Using  \(String(Int(usedVelocity)))")
                Button("Use 1")
                {
                    usedVelocity = 1
                }
                Button("Use 2")
                {
                    usedVelocity = 2
                }
                Button("Off")
                {
                    usedVelocity = 3
                }
            }
            HStack {
                VStack { // Integrals
                    Text("∫ (mi):")
                        .font(.system(size: 20))
                    HStack {
                        Text("\(rawDistanceIntegral/1600, specifier: "%.2f")")
                            .font(.system(size: 50))
                        Text("\(smoothedDistanceIntegral/1600, specifier: "%.2f")")
                            .font(.system(size: 50))

                    }
                }

                VStack { // Pace
                    Text("Pace (mi):")
                        .font(.system(size: 20))
                    HStack {
                        Text("\(26.6666667/GPS.rawVelocity, specifier: "%.2f")")
                            .font(.system(size: 50))
                        Text("\(26.6666667/GPS.smoothedVelocity, specifier: "%.2f")")
                            .font(.system(size: 50))
                    }
                }
            }

            
            HStack {
                Button("-10s")
                {
                    goalPace = max(goalPace - (1.0/6.0), lowestGoalPace)
                }
                .font(.system(size: 40))
                Text("Goal pace is \(String(goalPace)).")
                Button("+10s")
                {
                    goalPace = min(goalPace + (1.0/6.0), highestGoalPace)
                }
                .font(.system(size: 40))
            }
            Slider(value: $goalPace, in: lowestGoalPace...highestGoalPace, step: (1.0/6.0))
                .onChange(of: goalPace) { newValue in
                    goalPace = round(newValue*6.0) / 6.0
                    goalVelocity = 26.6666667 / goalPace
                }
                .padding(.horizontal)
                .padding(.bottom, 30)

            
            
            HStack {
                Button("-10")
                {
                    minTempo = max(minTempo - 10, lowestMinTempo)
                }
                .font(.system(size: 40))
                Text("Min \(String(Int(minTempo))), max \(String(Int(maxTempo)))")
                Button("+10")
                {
                    minTempo = min(minTempo + 10, highestMinTempo)
                }
                .font(.system(size: 40))
            }
            Slider(value: $minTempo, in: lowestMinTempo...highestMinTempo, step: 10)
                .onChange(of: minTempo) { newValue in
                    minTempo = round(newValue / 10) * 10
                    maxTempo = minTempo + 40.0
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                
                
            /*
             HStack { // MaxTempo
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
                .onChange(of: maxTempo) { newValue in
                    maxTempo = round(newValue / 10) * 10
                }
                    .padding(.horizontal)
             */
            
            /*Image(systemName: "waveform")
                .font(.system(size: 50))
                .foregroundStyle(.tint)
             */
        }
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor) // Set background color based on accelerometer data
        //.onChange(of: motionManager.accelerometerData.jerk) { //newValue in
        .onReceive(timer) { _ in // This runs at 30 FPS. That can be changed in the timer variable declaration at the top.
            
            rawDistanceIntegral += GPS.rawVelocity * framerate
            smoothedDistanceIntegral += GPS.smoothedVelocity * framerate
            
            if ((usedVelocity == 1 && GPS.rawVelocity <= goalVelocity) || (usedVelocity == 2 && GPS.smoothedVelocity <= goalVelocity)) { // or if false // you're going to slow
                //go faster
                matchingGoalPace = false
            } else {
                matchingGoalPace = true
            }
            
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
                
                if (matchingGoalPace) {
                    audioPlayer.rate = tempo / currentlyPlayingFileTempo
                } else {
                    audioPlayer.rate = (2 * tempo) / currentlyPlayingFileTempo
                }
                timeOfLastTempoCalculation = Date()
                
                // Set a record since it's the next stride.
                currentAccelerationRecord = motionManager.accelerometerData.total
                timeOfLastAccelerationRecord = Date()

            }
        }
    }
}


#Preview {
    ContentView()
}

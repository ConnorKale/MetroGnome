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
    @StateObject private var audioPlayer = VariableSpeedAudioPlayerPausing()
    @StateObject private var shepardAudioPlayer = VariableSpeedAudioPlayerPausing()
    @StateObject private var GPS = LocationManager()

    private let framerate: Double = (1.0/30.0) // Remember to change this and the timer!!!
    @State private var timer = Timer.publish(every: 1.0 / 30.0, on: .main, in: .common).autoconnect()

    //@State private var sliderValue: Double = 1.0

    // Update file names array, tempos array, extensions array, number of songs, proofread
    private var numberOfSongs: Int = 19
    @State private var selectedSongIndex: Int = 0
    private var songNames: [String] = ["MetroGnomeTestAudio_256Measures", "MetroGnomeTestAudio_256Measures", "MetroGnomeShepard'sTone", "MetroGnomeHalfstepShepard'sTone", "KorobeinikiPiano150", "KorobeinikiPiano150", "KorobeinikiString152+", "KorobeinikiString152+", "CanonMusicBox120", "WikipediaCanon160BPM", "WikipediaCanon160BPM", /* If in-line comments don't break the compiler this is the end of the wav files */ "WikipediaCanon160BPMisMP3", "90s", "DontFearTheReaper", "PartyUSA", "PartyUSA", "PartyCIA", "PartyCIA", "TheVeldt"]
    private var fileTempos: [Float] = [180.0, 90.0, 180.0, 180.0, 150.0, 75.0, 152.0, 76.0, 120.0, 160.0, 80.0, /* End of wavs */ 160.0, 158.0, 141.5, 192.0, 96.0, 192.0, 96.0, 180.0]
    private var fileExtensions: [String] = ["wav", "wav", "wav", "wav", "wav", "wav", "wav", "wav", "wav", "wav", "wav", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3"]
    
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
    @State private var usedVelocity: Int = 3 // This is what velocity algorithm you're using and should be an ∈ of {1, 2, 3}.
    @State private var usedPacingMethod: Int = 2 // 1 is doubling tempo, 2 is playing a beautiful shepards tone, 3 is extra beautiful shepards tone, 4 is stopping.
    @State private var goalPace: Double = 8.0 // This is in minutes per mile
    @State private var goalVelocity: Double = 3.333333338 // replace with 26.6666667/8
    @State private var lowestGoalPace: Double = 3.0
    @State private var highestGoalPace: Double = 15.0
    @State private var matchingGoalPace: Bool = true
    
    @State private var offsetCorrectionMultiplier: Float = 1.0
    
    @State private var currentAccelerationRecord: Double = 0.0
    @State private var timeOfLastAccelerationRecord: Date? = Date()
    @State private var timeOfLastTempoCalculation: Date? = Date()

    @State private var lastStrideTime: Double = 0.0 // In seconds
    @State private var secondLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var thirdLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var fourthLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var averageLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var tempo: Float = 180.0 // In seconds

    @State private var maxTempo: Double = 200.0
    @State private var minTempo: Double = 160
    @State private var lowestMinTempo: Double = 120.0
    @State private var highestMinTempo: Double = 190.0
    @State private var lowestMaxTempo: Double = 150.0
    @State private var highestMaxTempo: Double = 220.0

    private var backgroundColor: Color = Color(red: (57.0/256.0), green: (15.0/256.0), blue: (87.0/256.0)) // Purple // No more epilepsy // In your head as you read this average the red and blue values :) // FROM FUTURE 256!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    var body: some View {
        VStack {
            HStack {
                Button("Fstr") {
                    self.offsetCorrectionMultiplier = 1.1
                }
                Button("Slwr")
                {
                    self.offsetCorrectionMultiplier = 0.9
                }
                // Vowels are for poeple who aren't trying to conserve every possible pixel on the screen lol
                // Also why is XCode trying to recompile every time I add comments..?
            }
            .font(.system(size: 100))
            .padding(.bottom, -50)
            
            VStack(spacing: 20) {
                Button(audioPlayer.isPlaying ? "Stop" : "Play") {
                    if audioPlayer.isPlaying {
                        audioPlayer.stop()
                        shepardAudioPlayer.stop()
                    } else {
                        currentlyPlayingFileTempo = fileTempos[Int(selectedSongIndex)]
                        audioPlayer.loadAndPlay(filename: songNames[Int(selectedSongIndex)], fileExtension: fileExtensions[Int(selectedSongIndex)]) // your file name
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
                .padding(.bottom, -20)
                
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
            
            HStack { // Which Pacing method
                Text("Pacing  \(String(Int(usedPacingMethod)))")
                Button("Double")
                {
                    usedPacingMethod = 1
                }
                Button("Shepard")
                {
                    usedPacingMethod = 2
                }
                Button("Halfstep")
                {
                    usedPacingMethod = 3
                }
                Button("Off")
                {
                    usedPacingMethod = 4
                }
            }

            Text("Tempo:")
                .font(.system(size: 20))
            Text("\(tempo, specifier: "%.2f")")
                .font(.system(size: 80))
                .padding(.bottom, -20)
            
            HStack { // Which Velocity
                Text("GPS \(String(Int(usedVelocity)))")
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
                            .font(.system(size: 30))
                        Text("\(smoothedDistanceIntegral/1600, specifier: "%.2f")")
                            .font(.system(size: 30))

                    }
                }

                VStack { // Pace
                    Text("Pace (mi):")
                        .font(.system(size: 20))
                    HStack {
                        Text("\(26.6666667/GPS.rawVelocity, specifier: "%.2f")")
                            .font(.system(size: 30))
                        Text("\(26.6666667/GPS.smoothedVelocity, specifier: "%.2f")")
                            .font(.system(size: 30))
                    }
                }
            }

            
            HStack { // Goal pace text
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
            .padding(.bottom, -10)

            Slider(value: $goalPace, in: lowestGoalPace...highestGoalPace, step: (1.0/6.0)) // Goal pace slider
                .onChange(of: goalPace) { newValue in
                    goalPace = round(newValue*6.0) / 6.0
                    goalVelocity = 26.6666667 / goalPace
                }
                .padding(.horizontal)
                .padding(.bottom, -00)

            
            
            HStack {
                Button("-10") // Min/max tempo text
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
            .padding(.bottom, -10)

            Slider(value: $minTempo, in: lowestMinTempo...highestMinTempo, step: 10) // Min/max tempo slider
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
        // this is after the VStack I think.
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .preferredColorScheme(.dark)
        .background(backgroundColor) // Set background color based on accelerometer data
        //.onChange(of: motionManager.accelerometerData.jerk) { //newValue in
        .onReceive(timer) { _ in // This runs at 30 FPS. That can be changed in the timer variable declaration at the top.
            
            rawDistanceIntegral += GPS.rawVelocity * framerate
            smoothedDistanceIntegral += GPS.smoothedVelocity * framerate
            
            if ((usedVelocity == 1 && GPS.rawVelocity <= goalVelocity) || (usedVelocity == 2 && GPS.smoothedVelocity <= goalVelocity)) { // or if you've turned it off and then you're automaticially going fast enough// you're going to slow
                //go faster
                matchingGoalPace = false
            } else {
                // You're going fast enough.
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
                tempo = (60.0 * self.offsetCorrectionMultiplier)/Float(averageLastStrideTime)
                offsetCorrectionMultiplier = 1.0
                
                if (audioPlayer.isPlaying) {
                    if (matchingGoalPace || (usedPacingMethod == 4)) { // If you are matching the goal pace, or if you aren't getting paced
                        audioPlayer.rate = tempo / currentlyPlayingFileTempo
                    } else { // If you're not, we need to tell you somehow.
                        if (usedPacingMethod == 1)
                        {
                            audioPlayer.rate = (2 * tempo) / currentlyPlayingFileTempo
                        } else if (usedPacingMethod == 2) {
                            audioPlayer.rate = tempo / currentlyPlayingFileTempo
                            if (!shepardAudioPlayer.isPlaying)
                            {
                                shepardAudioPlayer.loadAndPlay(filename: "MetroGnomeShepard'sTone", fileExtension: "wav") // your .wav file name
                            }
                            shepardAudioPlayer.rate = tempo / 180.0
                        } else if (usedPacingMethod == 3) {
                            audioPlayer.rate = tempo / currentlyPlayingFileTempo
                            if (!shepardAudioPlayer.isPlaying)
                            {
                                shepardAudioPlayer.loadAndPlay(filename: "MetroGnomeHalfstepShepard'sTone", fileExtension: "wav") // your .wav file name
                            }
                            shepardAudioPlayer.rate = tempo / 180.0
                        }
                    }
                }
                
                if (matchingGoalPace || !audioPlayer.isPlaying || !(usedPacingMethod == 2 || usedPacingMethod == 3)) {
                    shepardAudioPlayer.stop()
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

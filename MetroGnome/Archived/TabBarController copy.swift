//
//  TabBarController.swift
//  MetroGnome
//
//  Created by Connor Kale on 10/26/25.
//

import SwiftUI
//import Combine // delete this later if it's not needed

// Use Command Shift L to get list of iOS images

// person.spatialaudio.fill waveform   person.spatialaudio.stereo.fill   apple.classical.pages.fill   sparkles   play.square   gearshape.2   text.document   repeat   speaker.wave.3   bell.fill   metronome   cat   hourglass   sum function graph.2d   iphone.homebutton.radiowaves.left.and.right.circle.fill   terminal.fill   shoe.front.lift   bell.and.waveform.fill   shoe.front.lift.fill


struct OldTabBarController: View {
    @StateObject private var motionManager = MotionManager()
    @StateObject private var audioPlayer = VariableSpeedAudioPlayer()
    @StateObject private var shepardAudioPlayer = VariableSpeedAudioPlayer()
    @StateObject private var GPS = LocationManager()
            
    @State private var tonePlayer = TonePlayer() // I think this has to be @State to go in the binding thingy
    @State private var tonePlayerMode: Int = 0 // 0 is not playing, 1 is needs to ascend, 2 is ascending and playing 440, 3 is ascending and playing 550, 4 is ascending and playing 660, 5 is needs to descend, 6 is descending and playing 660, 7 is descending and playing 550, 8 is descending and playing 440,
    @State private var timeOfLastToneChange: Date? = Date()
    @State private var elapsedToneChangeDouble: Double = 0.0

    private let framerate: Double = (1.0/30.0) // Remember to change this and the timer!!!
    @State private var timer = Timer.publish(every: 1.0 / 30.0, on: .main, in: .common).autoconnect()

    @State private var rawDistanceIntegral: Double = 0.0
    @State private var smoothedDistanceIntegral: Double = 0.0

    private let velocity3: Double = 10.43841336 // This is about Usain Bolt pace, in meters per second
    @State private var usedVelocity: Int = 3 // This is what velocity algorithm you're using and should be an ∈ of {1, 2, 3}.
    @State private var usedPacingMethod: Int = 2 // 1 is doubling tempo, 2 is playing a beautiful shepards tone, 3 is extra beautiful shepards tone, 4 is stopping.
    @State private var goalPaceMiles: Double = 8.0 // This is in minutes per mile
    @State private var goalPaceKilometers: Double = 5.0 // This is in minutes per kilometer
    @State private var goalVelocity: Double = 3.333333338 // replace with 26.6666667/8
    @State private var lowestGoalPace: Double = 3.0
    @State private var highestGoalPace: Double = 15.0
    @State private var matchingGoalPace: Bool = true
    
    @State private var offsetCorrectionMultiplier: Float = 1.0
    
    @State private var currentPlayingFileTempo: Float = 180.0
    
    @State private var currentAccelerationRecord: Double = 0.0
    @State private var timeOfLastAccelerationRecord: Date? = Date()
    @State private var timeOfLastTempoCalculation: Date? = Date()
    
    
    // Need binding for bool to count a stride, AverageLastStrideTime, MaxA, MinA,
    @State private var CollectionNeedsToCountAStride: Bool = false
    @State private var CollectionHighAccelerationRecord: Double = 0.0


    @State private var lastStrideTime: Double = 0.0 // In seconds
    @State private var secondLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var thirdLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var fourthLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var averageLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var tempo: Float = 180.0 // In seconds

    @State private var maxTempo: Double = 200.0
    @State private var minTempo: Double = 160
    
    @State private var radius: Double = 0.5 // m
    @State private var pitch: Double = 880 // Hz // 1 meter is A4, it plays at 440Hz/m. Max should be 880 Hz.
    @State private var gyroTonePlaying: Bool = false
    
    var body: some View {
        TabView {
            RunningStats(offsetButtonMultiplier: $offsetCorrectionMultiplier, theGPS: GPS, rawDistanceIntegral: $rawDistanceIntegral, smoothedDistanceIntegral: $smoothedDistanceIntegral)
                .tabItem {
                    Label("Stats", systemImage: "waveform.path.ecg.text.clipboard")
                }

            OldButtonsView(theAudioPlayer: audioPlayer, theShepardAudioPlayer: shepardAudioPlayer, theCurrentlyPlayingFileTempo: $currentPlayingFileTempo, theUsedVelocity: $usedVelocity, theUsedPacingMethod: $usedPacingMethod, theGoalPaceKilometers: $goalPaceKilometers, theGoalPaceMiles: $goalPaceMiles, theGoalVelocity: $goalVelocity, theTempo: $tempo, theMinTempo: $minTempo, theMaxTempo: $maxTempo)
                .tabItem {
                    Label("Buttons", systemImage: "play.circle")
                }

            OldPlaylist()
                .tabItem {
                    Label("Playlist", systemImage: "apple.classical.pages.fill")
                }
            /*SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }*/
            GPSDataCollection(tonePlayerMode: $tonePlayerMode, theGPS: GPS, theMotionManager: motionManager, theTempo: $tempo, StopAStride: $CollectionNeedsToCountAStride, LastStrideLength: $averageLastStrideTime, LowAccelerationRecord: $currentAccelerationRecord, HighAccelerationRecord: $CollectionHighAccelerationRecord)
                .tabItem {
                    Label("GPS Stuff", systemImage: "figure.run.square.stack")
                }
            
            /*GyroScopeUI(theMotionManager: motionManager, radius: $radius, TonePlayerIsPlaying: $gyroTonePlaying, tonePlayer: $tonePlayer)
                .tabItem {
                    Label("Gyroscope", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.page.on.clipboard")
                }*/
        } // Ah my beautiful spagetti algorithm. I might fix it later.
        .onReceive(timer) { _ in // This runs at 30 FPS. That can be changed in the timer variable declaration at the top in the TabBarController.
            
            //This is the gyroscope stuff:
            /* radius = motionManager.accelerometerData.total / (motionManager.gyroscopeData.total * motionManager.gyroscopeData.total)
            pitch = radius * 1760.0
            if (pitch > 7040)
            {
                pitch = 110.0
            }
            tonePlayer.setFrequency(pitch)
             */ // End of the gyroscope stuff

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
            
            if (motionManager.accelerometerData.total > CollectionHighAccelerationRecord) // This if statement in GPS experiment
            {
                CollectionHighAccelerationRecord = motionManager.accelerometerData.total
            }
            
            // Start of GPS Experiment
            // I think this should not be here   CollectionHighAccelerationRecord = motionManager.accelerometerData.total
            
            elapsedToneChangeDouble = Double(currentTime.timeIntervalSince(timeOfLastToneChange ?? currentTime)) // In seconds I hope

            
            // Tones are 440, 550, 660
            if (tonePlayerMode == 1)
            {
                tonePlayer.setFrequency(440)
                tonePlayer.start()
                timeOfLastToneChange = Date()
                tonePlayerMode = 2
                elapsedToneChangeDouble = Double(currentTime.timeIntervalSince(timeOfLastToneChange ?? currentTime)) // In seconds I hope
            }
            
            if (tonePlayerMode == 2 && (elapsedToneChangeDouble > (averageLastStrideTime/2))) // AND TIME
            {
                tonePlayer.setFrequency(550)
                timeOfLastToneChange = Date()
                tonePlayerMode = 3
                elapsedToneChangeDouble = Double(currentTime.timeIntervalSince(timeOfLastToneChange ?? currentTime)) // In seconds I hope
            }
            if (tonePlayerMode == 3 && (elapsedToneChangeDouble > (averageLastStrideTime/2))) // AND TIME
            {
                tonePlayer.setFrequency(660)
                timeOfLastToneChange = Date()
                tonePlayerMode = 4
                elapsedToneChangeDouble = Double(currentTime.timeIntervalSince(timeOfLastToneChange ?? currentTime)) // In seconds I hope
            }
            if (tonePlayerMode == 4 && (elapsedToneChangeDouble > (averageLastStrideTime))) // AND TIME
            {
                tonePlayer.setFrequency(0)
                // time doesn't matter
                tonePlayerMode = 0
            }
            
            
            // Tones are 440, 550, 660
            if (tonePlayerMode == 5)
            {
                tonePlayer.setFrequency(660)
                tonePlayer.start()
                timeOfLastToneChange = Date()
                tonePlayerMode = 6
                elapsedToneChangeDouble = Double(currentTime.timeIntervalSince(timeOfLastToneChange ?? currentTime)) // In seconds I hope
            }
            
            if (tonePlayerMode == 6 && (elapsedToneChangeDouble > (averageLastStrideTime/2))) // AND TIME
            {
                tonePlayer.setFrequency(550)
                timeOfLastToneChange = Date()
                tonePlayerMode = 7
                elapsedToneChangeDouble = Double(currentTime.timeIntervalSince(timeOfLastToneChange ?? currentTime)) // In seconds I hope
            }
            if (tonePlayerMode == 7 && (elapsedToneChangeDouble > (averageLastStrideTime/2))) // AND TIME
            {
                tonePlayer.setFrequency(440)
                timeOfLastToneChange = Date()
                tonePlayerMode = 8
                elapsedToneChangeDouble = Double(currentTime.timeIntervalSince(timeOfLastToneChange ?? currentTime)) // In seconds I hope
            }
            if (tonePlayerMode == 8 && (elapsedToneChangeDouble > (averageLastStrideTime))) { // AND TIME
                tonePlayer.stop()
                // time doesn't matter
                tonePlayerMode = 0
            }

            
            // End of GPS Experiment

                
            if (elapsedRecordDouble > Double(0.75*averageLastStrideTime)) {
                // Count a stride!
                
                
                
                CollectionNeedsToCountAStride = true // GPS
                
                
                
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
                        audioPlayer.rate = tempo / currentPlayingFileTempo
                    } else { // If you're not, we need to tell you somehow.
                        if (usedPacingMethod == 1)
                        {
                            audioPlayer.rate = (2 * tempo) / currentPlayingFileTempo
                        } else if (usedPacingMethod == 2) {
                            audioPlayer.rate = tempo / currentPlayingFileTempo
                            if (!shepardAudioPlayer.isPlaying)
                            {
                                shepardAudioPlayer.loadAndPlay(filename: "MetroGnomeShepard'sTone", fileExtension: "wav")
                            }
                            shepardAudioPlayer.rate = tempo / 180.0
                        } else if (usedPacingMethod == 3) {
                            audioPlayer.rate = tempo / currentPlayingFileTempo
                            if (!shepardAudioPlayer.isPlaying)
                            {
                                shepardAudioPlayer.loadAndPlay(filename: "MetroGnomeHalfstepShepard'sTone", fileExtension: "wav")
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
    OldTabBarController()
}

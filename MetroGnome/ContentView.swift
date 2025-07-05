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
    
    private let lowJerkWaterMark: Double = -4.0 //Left over from old stride-counting algorithm, now only used for screen colors.
    private let highJerkWaterMark: Double = 4.0 //Left over from old stride-counting algorithm, now only used for screen colors.
    //@State private var lookingForAboveHigh: Bool = true
    
    
    @State private var lowestAccelerationRecordInCurrentStep: Double = 144.0 // This is just a random number that's a lot biger than a feasable acceleration we could get.
    @State private var timeOfLastAccelerationRecord: Date? = Date()
    @State private var currentTime: Date? = Date()
    @State private var timeOfPreviousStride: Date? = Date() //Date(timeIntervalSince1970: 0) // This will make the first stride really long, since it started at the Unix Epoch.
    @State private var elapsedTime: TimeInterval?
    
    //@State private var startTime: Date?
    //@State private var endTime: Date?
    
    @State private var lastStrideTime: Double = 0.0 // In seconds
    @State private var secondLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var thirdLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var fourthLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var averageLastStrideTime: Double = (1.0/3.0) // In seconds
    @State private var tempo: Float = 180.0 // In seconds
    
    @State private var attemptingOffsetCorrection: Bool = false // If a file is not just a constant chord, this might sound weirder than it does otherwise.
    @State private var offsetAheadBy: Float = 0.0 // This is how far ahead we are, so if it's negative we're behind. This is in seconds, in units of the music file's seconds. If the file is a second ahead, this is equal to 1, no matter how fast you're running.
    @State private var nextStrideProjectedLength: Float = 0.0
    
    @State private var maxTempo: Double = 210.0 // Maybe change this back to 240? Or not, 210 is a really fast pace to run at but in theory it's possible.
    @State private var minTempo: Double = 120.0
    @State private var minTempoIs120: Bool = true
    
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
                        offsetAheadBy = 0.0
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
                .font(.system(size: 40))
            
            Text("Last stride (s):")
                .font(.system(size: 20))
            Text("\(lastStrideTime, specifier: "%.2f")")
            //.padding()
                .font(.system(size: 40))
            
            Text("Average of last four (s):")
                .font(.system(size: 20))
            Text("\(averageLastStrideTime, specifier: "%.2f")")
            //.padding()
                .font(.system(size: 80))
            
            Text("Accumulated offset (fileseconds):")
                .font(.system(size: 20))
            Text("\(offsetAheadBy, specifier: "%.2f")")
            //.padding()
                .font(.system(size: 80))

            
            Button(minTempoIs120 ? "Min tempo to 150" : "Min tempo to 120") {
                if minTempoIs120 {
                    minTempo = 150
                    minTempoIs120 = false
                } else {
                    minTempo = 120
                    minTempoIs120 = true
                }
            }
            .font(.system(size: 40))
            Button(attemptingOffsetCorrection ? "Stop Error Correction" : "Start Error Correction") {
                attemptingOffsetCorrection = !attemptingOffsetCorrection
            }
            .font(.system(size: 40))
            
            /*Image(systemName: "waveform")
             .font(.system(size: 50))
             .foregroundStyle(.tint)
             */
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor) // Set background color based on accelerometer data
        /*.onAppear {
            //motionManager.startUpdates()
        }
        .onDisappear {
            //motionManager.stopUpdates()
        }*/
        
        /*.onChange(of: motionManager.accelerometerData.jerk) { newValue in
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
         }*/
        .onChange(of: motionManager.accelerometerData.jerk) { //newValue in
            
            if let start = timeOfLastAccelerationRecord { // This sets "elapsedTime" to the time since the last record was set.
                currentTime = Date()
                elapsedTime = currentTime?.timeIntervalSince(start)
            } else {
                elapsedTime = nil
            }
            
            if let elapsed = elapsedTime { // elapsed is the number of seconds since the last record was set.
                
                if (motionManager.accelerometerData.total < lowestAccelerationRecordInCurrentStep && elapsed < averageLastStrideTime * 0.5) // Below the record && it's been less than half a stride since the last record being set, so it's the same stride
                {
                    // We're setting a record now, since we broke the previous one.
                    lowestAccelerationRecordInCurrentStep = motionManager.accelerometerData.total
                    timeOfLastAccelerationRecord = Date()
                }
                
                if (elapsed > averageLastStrideTime * 0.5) // It's been more than half a stride, record was unbroken
                {
                    // That was a beat, do stuffs
                    
                    if let lastStride = timeOfPreviousStride {
                        let lastStrideDuration = (timeOfLastAccelerationRecord?.timeIntervalSince(lastStride)) ?? 0.0 // This is a double!!! :)
                        // Find how much error we created.
                        // if lastStrideDuration is smaller than nextStrideProjectedLength, it was to short and the file got behind, since it didn't get through the full beat before the next stride happened. That means offsetAheadBy should become more negative, so we should say new offsetAheadBy is proportional to (lastStrideDuraton - nextStrideProjectedLength)
                        //(lastStrideDuraton - nextStrideProjectedLength) is the number of realseconds we got ahead by.
                        // Say our step took half an extra realsecond. Say the file is playing at 3x rate. Then we would have gotten ahead by 1/6 fileseconds. (lastStrideDuraton - nextStrideProjectedLength)/audioPlayer.rate would be what gets added to offsetAheadBy.
                        offsetAheadBy += ((Float(lastStrideDuration) - nextStrideProjectedLength)*audioPlayer.rate) // Autocorrect is creepy.
                        
                        //audioPlayer.rate is equal to 1, or some number of fileseconds/realsecond.
                        
                        // Old forthStride's data gets forgotten
                        fourthLastStrideTime = thirdLastStrideTime
                        thirdLastStrideTime = secondLastStrideTime
                        secondLastStrideTime = lastStrideTime
                        lastStrideTime = min((1/(minTempo/60.0)), (max((1/(maxTempo/60.0)), lastStrideDuration)))
                        
                        averageLastStrideTime = ((fourthLastStrideTime + thirdLastStrideTime + secondLastStrideTime + lastStrideTime)/4.0) // Find a new average BPM.
                        
                        tempo = 60.0/Float(averageLastStrideTime) // This is the tempo the user is running at.
                        
                         
                         // Let's assume the next stride will happen in averageLastStrideTime realseconds. We have two choices: either the file will play such that the current beat will finish in averageLastStrideTime realseconds, or the next beat will finish in averageLastStrideTime realseconds. We should find what correctingOffsetTempo is required for both options, and then use whichever one is closer to the actual tempo.
                        // The tempo of the file, in fileHz, is fileTempo/60. Each beat takes 60/fileTempo fileseconds. Say each beat takes 2 fileseconds and we're ahead by 1/3 fileseconds. Then we're ahead by 1/6 beats. We're ahead by ((# of filesecond's we're ahead by)/(beat length in fileseconds)) beats. Were ahead by (offsetAheadBy/(60/fileTempo)) beats.
                        
                        //The ammount of the current beat we have left is 1-(offsetAheadBy/(60/fileTempo)) beats.
                        // If we want to finish the current beat by next stride, we should go through 1-(offsetAheadBy/(60/fileTempo)) beats.
                        // If we want to finish the current beat and another one by next stride, we should go through (1-(offsetAheadBy/(60/fileTempo))) + 1 or 2-(offsetAheadBy/(60/fileTempo))
                        
                        // If we want to do 1 beat over the next stride (so not do error correction) we should play at 1 * tempo/fileTempo. We should do (# of beats we want to go through) * (tempo/fileTempo) as audioPlayer.rate
                        
                        // If we want to finish the current beat, audioPlayer.rate = (1-(offsetAheadBy/(60/fileTempo))) * tempo/fileTempo
                        // If we want to finish the next beat, audioPlayer.rate = (2-(offsetAheadBy/(60/fileTempo))) * tempo/fileTempo
                        // We should use whichever is closer to tempo/fileTempo is used, or whichever of (1-(offsetAheadBy/(60/fileTempo))) and (2-(offsetAheadBy/(60/fileTempo))) is closer to 1.
                        
                        if (attemptingOffsetCorrection)
                        {
                            
                            // audioPlayer.rate = 60/(projected next stride time) * fileTempo
                            // audioPlayer.rate * projected = 60/fileTempo
                            // projected = 60/fileTempo * audioPlayer.rate
                            let beatsLeftInCurrentBeat = (1-(offsetAheadBy/(60.0/fileTempo))) // This should be smaller than one. One/this is greater than one.
                            let beatsLeftUntilNextBeat = (2-(offsetAheadBy/(60.0/fileTempo))) // This should be greater than one.
                            
                            if ((1/beatsLeftInCurrentBeat) > beatsLeftUntilNextBeat)  // If you use an < instead of an >, and flip the if statement, you get some fun results :)
                            {
                                // there is a small amount of the current beat left, we should finish the next beat.
                                audioPlayer.rate = beatsLeftUntilNextBeat * tempo/fileTempo
                            } else {
                                // There is a small amount of the current beat done, we should finish it now.
                                audioPlayer.rate = beatsLeftInCurrentBeat * tempo/fileTempo
                            }
                            
                            nextStrideProjectedLength = 60/(fileTempo*audioPlayer.rate)
                            
                        }
                        
                        if (!attemptingOffsetCorrection) {
                            audioPlayer.rate = tempo/fileTempo // Times 1 since we're doing one beat over the next stride.
                            
                            nextStrideProjectedLength = Float(averageLastStrideTime)
                        }
                        
                        
                    }
                    
                    timeOfPreviousStride = timeOfLastAccelerationRecord
                    
                    //We're setting a record, since it's a new beat and this is the first recorded acceleration of that beat.
                    lowestAccelerationRecordInCurrentStep = motionManager.accelerometerData.total
                    timeOfLastAccelerationRecord = Date()
                }
            }
        }
        
    }
    
    //func changeNote() {
        // Make a noticable change in the pitch for the user.
        // Change the note
                
    //}
}


#Preview {
    ContentView()
}

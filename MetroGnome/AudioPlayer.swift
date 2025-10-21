//
//  AudioPlayer.swift
//  MetroGnome
//
//  Created by Connor Kale on 6/29/25.
//

import SwiftUI

import Foundation
import AVFoundation

class VariableSpeedAudioPlayer: ObservableObject {
    private var engine = AVAudioEngine()
    private var playerNode = AVAudioPlayerNode()
    private var timePitch = AVAudioUnitTimePitch()
    private var audioFile: AVAudioFile?

    @Published var songProgress: Double = 0.0
    private var elapsedTime: TimeInterval = 0
    private var timer: Timer?
    private var timerTicking = false

    private var playbackStartTime: TimeInterval = 0
    private var pausedTime: TimeInterval = 0

    @Published var isPlaying = false // This is whether the audio is currently playing or not.
    @Published var songGoing = false // This is whether a song has been started and is partially played, whenther it's been paused or not.
    @Published var rate: Float = 1.0 {
        didSet {
            timePitch.rate = rate
        }
    }

    init() {
        setupAudioEngine()
    }

    private func setupAudioEngine() {
        engine.attach(playerNode)
        engine.attach(timePitch)

        // Connect playerNode -> timePitch -> output
        engine.connect(playerNode, to: timePitch, format: nil)
        engine.connect(timePitch, to: engine.mainMixerNode, format: nil)

        do {
            try engine.start()
        } catch {
            print("❌ 1 Engine failed to start: \(error.localizedDescription)")
        }
    }

    func decodeFile(inputFileName: String, inputFileExtension: String) -> URL {
        print("8 Trying to decode \(inputFileName)")
        
        var tempDirectoryURL = FileManager.default.temporaryDirectory
        
        let uniqueFilename = "TemporaryDecodedWaveFile.tmp"
        var temporaryFileURL = tempDirectoryURL.appendingPathComponent(uniqueFilename)

        
        guard let oldUrl: URL = Bundle.main.url(forResource: inputFileName, withExtension: inputFileExtension) else {
            print("2 ❌ error")
            return URL("Test")!
        }
        
        do {
            var options = AKConverter.Options()
            // any options left nil will assume the value of the input file
            options.format = "wav"
            options.sampleRate = 48000
            options.bitDepth = 24

            let converter = AKConverter(inputURL: oldUrl, outputURL: temporaryFileURL, options: options)
            converter.start(completionHandler: { error in
                // check to see if error isn't nil, otherwise you're good
                print("7 AKConverter tried to decode the following file: \(oldUrl)")
                print(error)
                print("3 AKConverter tried to run")
            })

            //sleep(10)
            
            return temporaryFileURL
        }
    }
    
    func loadAndPlay(filename: String, fileExtension: String) {
        var playedUrl: URL
        
        if (fileExtension != "wav") { // If I'm not inputing a wav file, decode it and write the decoded copy to TemporaryFile.wav
            // It's not a wav file, convert it and then play the decoded copu
            var DecodedUrl = self.decodeFile(inputFileName: filename, inputFileExtension: fileExtension)

            playedUrl = DecodedUrl
            print("4 Playing MP3 at DecodedUrl of \(DecodedUrl)")

        } else {
            // It is a wav file, just play the original copy
            guard let url = Bundle.main.url(forResource: filename, withExtension: "wav") else {
                print("5 ❌ Audio file not found.")
                return
            }
            playedUrl = url

        }
        

        do {
            audioFile = try AVAudioFile(forReading: playedUrl)
            if let file = audioFile {
                playerNode.stop()
                playerNode.scheduleFile(file, at: nil, completionHandler: nil)

                if !engine.isRunning {
                    try engine.start()
                }

                playerNode.play()
                isPlaying = true
            }
        } catch {
            print("6 ❌ Error loading audio file: \(error)")
        }
    }

    func start() {
        // Load and play file at specific point, needs to take inputs about what file to load
        resetTimer()
        startTimer()
        isPlaying = true
        songGoing = true
    }
    
    func stop() { // stop the audio
        playerNode.stop()
        isPlaying = false
        songGoing = false
        pauseTimer()
        resetTimer()
    }
    
    //When start or unpause, start a timer. When I pause, stop the timer. Also publish the timer so I can attatch it to a slider in the ContentView. When I stop, reset the timer. Start with the timer at zero.
    func pause() {
        pauseTimer()
        playerNode.stop()
        isPlaying = false
        // songGoing stays true
        // Don't reset the timer
    }
    
    func resume() // Start the song from current point which might be 0, start timer from current point which might be 0, set playing variables to trjue
    {
        startTimer() // at current point
        playerNode.play() // from current point..? This might do it automaticially
        isPlaying = true
        songGoing = true
    }
    
    // func resume start audioPlayer at the timer, resume the timer.
    
    // We don't need full timer functionality. Possible states we can be in: no song is playing (so the timer = 0, and when we start we want to start the song and timer at where the timer is), we're playing a song (so the timer is going, and we want to be able to stop audio and reset the timer or pause, stop audio and pause the timer) or we're paused (so we want to be able to start audio where we left off or reset everything).
    // We need a funcion to start the audio from the beginning (so start it and reset and start the timer), a funciton to resume the audio from at a specic point (which might be 0), a function to stop it and reset and stop the timer, and a funcion to pause (stop audio, start timer).
    // We also need a funciton to start the timer from wherever it is, pause it and remember where it is, and reset it.
    
    func startTimer() { // In theory this starts the timer from wherever it is.
        guard !timerTicking else { return }
        timerTicking = true

        timer = Timer.scheduledTimer(withTimeInterval: (1.0 / 30.0), repeats: true) { _ in
            // record what it last was, if it's not equal to that the user messed with it with the slider.
            self.elapsedTime += (1.0/30.0) * Double(self.rate)
            self.songProgress = Double(self.elapsedTime)
        }

        // Make sure the timer keeps firing while scrolling, etc.
        RunLoop.current.add(timer!, forMode: .common)
    }

    func pauseTimer() { // In theory this pauses the timer without reseting the elapsedTime.
        timer?.invalidate()
        timer = nil
        timerTicking = false
    }

    func resetTimer() { // This sets the timer back to zero but doesn't pause it. I have to call it after I call the funciton to pause it.
        elapsedTime = 0
        songProgress = 0
    }

}

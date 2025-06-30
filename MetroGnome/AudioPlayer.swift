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

    @Published var isPlaying = false
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
            print("❌ Engine failed to start: \(error.localizedDescription)")
        }
    }

    func loadAndPlay(filename: String, fileExtension: String = "wav") {
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            print("❌ Audio file not found.")
            return
        }

        do {
            audioFile = try AVAudioFile(forReading: url)
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
            print("❌ Error loading audio file: \(error.localizedDescription)")
        }
    }

    func stop() {
        playerNode.stop()
        isPlaying = false
    }
}

//
//  TonePlayer.swift
//  Gnome
//
//  Created by Connor Kale on 4/27/25.
//  Actually created by ChatGPT on 5/06/25.

import AVFoundation

class TonePlayer {
    private let engine = AVAudioEngine()
    private var sourceNode: AVAudioSourceNode!
    
    private var frequency: Double = 110.0  // default Hz
    private var sampleRate: Double = 44100.0
    private var amplitude: Double = 0
    private var theta: Double = 0.0

    init() {
        let output = engine.outputNode
        let format = output.inputFormat(forBus: 0)
        sampleRate = format.sampleRate

        sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let thetaIncrement = 2.0 * Double.pi * self.frequency / self.sampleRate

            for frame in 0..<Int(frameCount) {
                let sampleVal = Float(sin(self.theta) * self.amplitude)
                self.theta += thetaIncrement
                if self.theta > 2.0 * Double.pi {
                    self.theta -= 2.0 * Double.pi
                }
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = sampleVal
                }
            }
            return noErr
        }

        engine.attach(sourceNode)
        engine.connect(sourceNode, to: engine.mainMixerNode, format: format)
        engine.mainMixerNode.outputVolume = 2.0 // max is 1.0, default is 1.0

    }

    func start() {
        do {
            try engine.start()
        } catch {
            print("Error starting engine: \(error.localizedDescription)")
        }
    }

    func stop() {
        engine.stop()
    }

    func setFrequency(_ freq: Double) {
        if (freq == 0) {
            amplitude = 0
        } else {
            amplitude = 1
            frequency = max(1.0, min(freq, 2000.0)) // clamp to safe range. Max is like 15 gs, were probably not running that fast.
        }
    }
}//
//  ContentView.swift
//  Gnome
//
//  Created by Connor Kale on 4/24/25.
//

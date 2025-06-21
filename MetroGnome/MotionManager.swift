//
//  MotionManager.swift
//  MetroGnome
//
//  Created by Connor Kale on 4/24/25.
//

import CoreMotion

class MotionManager: ObservableObject { // To do: Clean this up after I understand SwiftUI better. Check if updateInterval is too high
    // Original MotionManager Stuff {
    private let motionManager = CMMotionManager()
    private let updateInterval = 0.008 //0.0002 //In seconds // This might be too high and make it crash...
    
    @Published var accelerometerData: (x: Double, y: Double, z: Double, total: Double, rotationalJerk: Double, absoluteJerk: Double) = (0, 0, 0, 0, 0, 0)
    //}
    // My Jerk Calculator {
    private var oldX = 0.0
    private var oldY = 0.0
    private var oldZ = 0.0
    private var oldAbsolute = 0.0
    //}
    
    init() {
        startAccelerometerUpdates()
    }
    
    private func startAccelerometerUpdates() {
        guard motionManager.isAccelerometerAvailable else {
            print("Accelerometer is not available.")
            return
        }

        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self = self else { return }   // unwrap self safely // From CrapGPT
            
            guard let data = data else {
                if let error = error {
                    print("Accelerometer error: \(error.localizedDescription)")
                }
                return
            }
            
            // Update non-jerk stuff, calculate dj's with old values and find dx, divide by updateInterval for dt, find non-rotational dx/dt, publish results, update old values to current ones for next frame's calculation.
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            let total = sqrt(x * x + y * y + z * z)
            
            let dx = x - self.oldX
            let dy = y - self.oldY
            let dz = z - self.oldZ
            let da = total - self.oldAbsolute
            
            let dt = updateInterval //Might be problems if updateInterval is greater than the framerate?
            
            let slopeX = dx/dt
            let slopeY = dy/dt
            let slopeZ = dz/dt
            let jerkRotation = sqrt(slopeX * slopeX + slopeY * slopeY + slopeZ * slopeZ)
            let jerkAbsolute = da/dt
            
            self.accelerometerData = (x, y, z, total, jerkRotation, jerkAbsolute)
            
            oldX = x
            oldY = y
            oldZ = z
            oldAbsolute = total
        }
    }
    deinit {
        motionManager.stopAccelerometerUpdates()
    }
}

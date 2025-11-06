//
//  MotionManager.swift
//  MetroGnome
//
//  Created by Connor Kale on 4/24/25.
//

import CoreMotion

class MotionManager: ObservableObject { // To do: Clean this up after I understand SwiftUI better. Check if updateInterval is too high
    private let motionManager = CMMotionManager()
    private let updateInterval = (1.0/30.0) //In seconds // This might be too high and make it crash...
    
    @Published var accelerometerData: (x: Double, y: Double, z: Double, total: Double, jerk: Double) = (0, 0, 0, 0, 0)

    private var oldAccelerometerTotal = 0.0 // Some accelerometer thing
    
    private var rotationRate: CMRotationRate = CMRotationRate(x: 0, y: 0, z: 0)
    
    @Published var gyroscopeData: (x: Double, y: Double, z: Double, total: Double) = (0, 0, 0, 0)
    
    init() {
        startGyroscope()
        startAccelerometerUpdates()
    }
    
    func startGyroscope() {
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = updateInterval  // in Hz
            motionManager.startGyroUpdates(to: .main) { [weak self] (data, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self?.rotationRate = data.rotationRate
                    }
                }
            }
        } else {
            print("Gyroscope not available.")
        }
    }
    
    private func startAccelerometerUpdates() {
        guard motionManager.isAccelerometerAvailable else {
            print("Accelerometer is not available.")
            return
        }

        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self = self else { return }   // unwrap self safely
            
            guard let data = data else {
                if let error = error {
                    print("Accelerometer error: \(error.localizedDescription)")
                }
                return
            }
            
            // Update non-jerk stuff, calculate dj's with old values and find dx, divide by updateInterval for dt, find non-rotational dx/dt, publish results, update old values to current ones for next frame's calculation.
            let aX = data.acceleration.x
            let aY = data.acceleration.y
            let aZ = data.acceleration.z
            let aTotal = sqrt(aX * aX + aY * aY + aZ * aZ)
            
            let da = aTotal - self.oldAccelerometerTotal
            let dt = updateInterval //Might be problems if updateInterval is greater than the framerate?
            let jerkAbsolute = da/dt
            
            self.accelerometerData = (aX, aY, aZ, aTotal, jerkAbsolute)
            
            oldAccelerometerTotal = aTotal // For next frame's calculation.
            
            
            let gyroTotal: Double = sqrt(rotationRate.x * rotationRate.x + rotationRate.y * rotationRate.y + rotationRate.z * rotationRate.z)
            
            gyroscopeData = (Double(rotationRate.x), Double(rotationRate.y), Double(rotationRate.z), gyroTotal)
        }
    }
    deinit {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
    }
}

//
//  LocationManager.swift
//  MetroGnome
//
//  Created by Connor Kale on 10/6/25.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var rawVelocity: Double = 0.0 // in m/s
    @Published var smoothedVelocity: Double = 0.0 // in m/s
    private var startedSmoothedVelocity: Bool = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        rawVelocity = max(0, lastLocation.speed) // speed can be -1 if invalid
        if (startedSmoothedVelocity) {
            smoothedVelocity = (smoothedVelocity * 0.8) + (rawVelocity * 0.2)
        } else {
            smoothedVelocity = rawVelocity
            startedSmoothedVelocity = true
        }
    }
}

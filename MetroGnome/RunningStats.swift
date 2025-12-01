//
//  RunningStats.swift
//  MetroGnome
//
//  Created by Connor Kale on 10/26/25.
//

import SwiftUI

struct RunningStats: View {
    // @Binding some variable name owned by the TabBarController
    @Binding var offsetButtonMultiplier: Float
    
    @ObservedObject var theGPS: LocationManager // Outputs stuff in m/s

    @Binding var rawDistanceIntegral: Double // m
    @Binding var smoothedDistanceIntegral: Double // m
    var body: some View {
        ScrollView {
            VStack {
                Text("Hello, World!")
                
                VStack {
                    Button("Ahead 0.1 beats") {
                        offsetButtonMultiplier = 1.1
                    }
                    .font(.system(size: 50))
                    Button("Back 0.1 beats")
                    {
                        offsetButtonMultiplier = 0.9
                    }
                    .font(.system(size: 50))
                }
                .font(.system(size: 100))
                .padding(.bottom, 70)
                
                //    \(somevariablename, specifier: "%.2f")
                
                Text("Raw, smoothed")
                    .font(.system(size: 20))

                Text("∫ (m): \(rawDistanceIntegral, specifier: "%.2f") | \(smoothedDistanceIntegral, specifier: "%.2f")")
                    .font(.system(size: 30))
                    .padding(.bottom, 20)
                Text("∫ (mi): \(rawDistanceIntegral/1600, specifier: "%.2f") | \(smoothedDistanceIntegral/1600, specifier: "%.2f")")
                    .font(.system(size: 30))
                    .padding(.bottom, 20)
                Text("∫ (km): \(rawDistanceIntegral/1000, specifier: "%.2f") | \(smoothedDistanceIntegral/1000, specifier: "%.2f")")
                    .font(.system(size: 30))
                    .padding(.bottom, 50)

                Text("V (m/s): \(theGPS.rawVelocity, specifier: "%.2f") | \(theGPS.smoothedVelocity, specifier: "%.2f")")
                    .font(.system(size: 30))
                    .padding(.bottom, 50)

                Text("P (min/km): \(16.6666667/theGPS.rawVelocity, specifier: "%.2f") | \(16.6666667/theGPS.smoothedVelocity, specifier: "%.2f")")
                    .font(.system(size: 30))
                    .padding(.bottom, 20)
                Text("P (min/mi): \(26.6666667/theGPS.rawVelocity, specifier: "%.2f") | \(26.6666667/theGPS.smoothedVelocity, specifier: "%.2f")")
                    .font(.system(size: 30))
                    .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .preferredColorScheme(.dark)
            .background(Color(red: (13/255.0), green: (67.0/255.0), blue: (67.0/255.0)))
        }
    }
}

#Preview {
 TabBarController()
}

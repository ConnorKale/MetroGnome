//
//  GPSDataDisplay.swift
//  MetroGnome
//
//  Created by Connor Kale on 11/10/25.
//

import SwiftUI

struct GPSDataDisplay: View {
    // Data: tempo, abs acceleration integral, absolute a integral minus g, abs acceleration integral per stride, average abs a int per stride / time, max a, min a, gyro stuff, pace, number of steps
    //@Binding public var data: [(AverageTempo: Double, AbsoluteAccelerationIntegral: Double, AbsoluteAIntegralMinusG: Double, AverageAbsoluteAccelerationIntegralPerStride: Double, AverageAbsoluteAccelerationIntegralPerStrideOverTime: Double, MaxAccelerationPerStride: Double, MinAccelerationPerStride: Double, GyroStuff: Double, Time: Double, Pace: Double, NumberOfSteps: Double, Tempo: Double)]

    var body: some View {
        VStack {
            Text("Hello, World!")
            //ForEach(data.indices, id: \.self) { item in
                HStack {
                    // Text(data[item].First)
                    // Text(data[item].Second)
                }
            //}
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .preferredColorScheme(.dark)
        .background(Color(red: (42.0/256.0), green: (13.0/256.0), blue: (13.0/256.0)))
    }
}
/*
#Preview {
    //GPSDataDisplay()
}*/

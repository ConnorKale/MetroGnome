//
//  GPSDataDisplay.swift
//  MetroGnome
//
//  Created by Connor Kale on 11/10/25.
//

import SwiftUI

struct GPSDataDisplay: View {
    // Data: tempo, abs acceleration integral, absolute a integral minus g, abs acceleration integral per stride, average abs a int per stride / time, max a, min a, gyro stuff, pace, number of steps
    @Binding public var DisplayData: [(AbsoluteAccelerationIntegral: Double, AbsoluteAccelerationIntegralMinusG: Double, AverageAbsoluteAccelerationIntegralPerStride: Double, AverageAbsoluteAccelerationIntegralPerStrideMinusG: Double, AbsoluteJerkIntegral: Double, AbsoluteJerkIntegralPerStride: Double, AverageAbsoluteAccelerationIntegralPerStrideWeightedByLength: Double, MaxAccelerationPerStrideSum: Double, MinAccelerationPerStrideSum: Double, MaxAccelerationPerStride: Double, MinAccelerationPerStride: Double, GyroIntegral: Double, FrameCount: Double, NumberOfSteps: Double, TempoIntegral: Double, AverageTempo: Double, SignedTempoOffset:Double, AbsoluteTempoOffset:Double, OSDistance: Double)]
    public var SomeNumberVariableName: Double = 0 // for compiler, dletre this

    var body: some View {
        ScrollView {
            VStack {
                ForEach(DisplayData.indices, id: \.self) { indexNumber in
                    /*HStack{
                        //Text("Data point \(indexNumber): | \(SomeNumberVariableName, specifier: "%.2f") | \(SomeNumberVariableName, specifier: "%.2f") | \(SomeNumberVariableName, specifier: "%.2f") | \(SomeNumberVariableName, specifier: "%.2f") | \(SomeNumberVariableName, specifier: "%.2f") | ")
                        // Need to convert Doubles to rounded strings
                        Text("\(DisplayData[indexNumber].AbsoluteAccelerationIntegral, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].AverageAbsoluteAccelerationIntegralPerStride, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].AverageAbsoluteAccelerationIntegralPerStrideMinusG, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].AbsoluteJerkIntegral, specifier: "%.2f") |")
                        
                        Text("\(DisplayData[indexNumber].AbsoluteJerkIntegralPerStride, specifier: "%.2f") |")
                        
                        Text("\(DisplayData[indexNumber].AverageAbsoluteAccelerationIntegralPerStrideWeightedByLength, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].MaxAccelerationPerStrideSum, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].MinAccelerationPerStrideSum, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].MaxAccelerationPerStride, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].MinAccelerationPerStride, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].GyroIntegral, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].FrameCount, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].NumberOfSteps, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].TempoIntegral, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].AverageTempo, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].SignedTempoOffset, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].AbsoluteTempoOffset, specifier: "%.2f") |")
                        Text("\(DisplayData[indexNumber].OSDistance, specifier: "%.2f") ")
                        // Need to convert Doubles to rounded strings
                        // and so on
                    }
                    .padding(.bottom, 200)*/
                    Text("\(DisplayData[indexNumber].AbsoluteAccelerationIntegral, specifier: "%.2f") | \(DisplayData[indexNumber].AbsoluteAccelerationIntegralMinusG, specifier: "%.2f") | \(DisplayData[indexNumber].AverageAbsoluteAccelerationIntegralPerStride, specifier: "%.2f") | \(DisplayData[indexNumber].AverageAbsoluteAccelerationIntegralPerStrideMinusG, specifier: "%.2f") | \(DisplayData[indexNumber].AbsoluteJerkIntegral, specifier: "%.2f") | \(DisplayData[indexNumber].AbsoluteJerkIntegralPerStride, specifier: "%.2f") | \(DisplayData[indexNumber].AverageAbsoluteAccelerationIntegralPerStrideWeightedByLength, specifier: "%.2f") | \(DisplayData[indexNumber].MaxAccelerationPerStrideSum, specifier: "%.2f") | \(DisplayData[indexNumber].MinAccelerationPerStrideSum, specifier: "%.2f") | \(DisplayData[indexNumber].MaxAccelerationPerStride, specifier: "%.2f") | \(DisplayData[indexNumber].MinAccelerationPerStride, specifier: "%.2f") | \(DisplayData[indexNumber].GyroIntegral, specifier: "%.2f") | \(DisplayData[indexNumber].FrameCount, specifier: "%.2f") | \(DisplayData[indexNumber].NumberOfSteps, specifier: "%.2f") | \(DisplayData[indexNumber].TempoIntegral, specifier: "%.2f") | \(DisplayData[indexNumber].AverageTempo, specifier: "%.2f") | \(DisplayData[indexNumber].SignedTempoOffset, specifier: "%.2f") | \(DisplayData[indexNumber].AbsoluteTempoOffset, specifier: "%.2f") | \(DisplayData[indexNumber].OSDistance, specifier: "%.2f") ")
                        .font(.system(size: 20))
                        .padding(.bottom, 30)

                }
            }
            .padding(.bottom, 677) // A prime number
            .preferredColorScheme(.dark)
            .background(Color(red: (0.0/255.0), green: (100.0/255.0), blue: (100.0/255.0)))
        }
    }
}

#Preview {
    TabBarController()
}

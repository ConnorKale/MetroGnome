//
//  GPSDataCollection.swift
//  MetroGnome
//
//  Created by Connor Kale on 11/10/25.
//

import SwiftUI

struct GPSDataCollection: View {
    @Binding public var tonePlayerMode: Int
    //Variables go here
    
    @State public var isRecording: Bool = false
    @State public var CollectionNeedsToEndCurrentPoint: Bool = false

    // need input from GPS, accelerometer, step/tempo algorithm, and a framerate
    @ObservedObject var theGPS: LocationManager // Outputs stuff in m/s
    @ObservedObject var theMotionManager: MotionManager
    
    @Binding public var theTempo: Float
    @Binding public var StopAStride: Bool
    @Binding public var LastStrideLength: Double
    @Binding public var LowAccelerationRecord: Double
    @Binding public var HighAccelerationRecord: Double
    
    @State public var CurrentStrideAccelerationIntegral: Double = 0.0
    @State public var AbsoluteAccelerationIntegralPerStrideWeightedByLength: Double = 0.0
    
    private let framerate: Double = (1.0/30.0) // Remember to change this and the timer!!!
    @State private var timer = Timer.publish(every: 1.0 / 30.0, on: .main, in: .common).autoconnect()

    
    @State public var Data: [(AbsoluteAccelerationIntegral: Double, AbsoluteAccelerationIntegralMinusG: Double, AverageAbsoluteAccelerationIntegralPerStride: Double, AverageAbsoluteAccelerationIntegralPerStrideMinusG: Double, AbsoluteJerkIntegral: Double, AbsoluteJerkIntegralPerStride: Double, AverageAbsoluteAccelerationIntegralPerStrideWeightedByLength: Double, MaxAccelerationPerStrideSum: Double, MinAccelerationPerStrideSum: Double, MaxAccelerationPerStride: Double, MinAccelerationPerStride: Double, GyroIntegral: Double, FrameCount: Double, NumberOfSteps: Double, TempoIntegral: Double, AverageTempo: Double, SignedTempoOffset:Double, AbsoluteTempoOffset:Double, OSDistance: Double)] = [/*It starts out empty*/]
    
    @State public var CurrentDataPoint: (AbsoluteAccelerationIntegral: Double, AbsoluteAccelerationIntegralMinusG: Double, AverageAbsoluteAccelerationIntegralPerStride: Double, AverageAbsoluteAccelerationIntegralPerStrideMinusG: Double, AbsoluteJerkIntegral: Double, AbsoluteJerkIntegralPerStride: Double,  AverageAbsoluteAccelerationIntegralPerStrideWeightedByLength: Double, MaxAccelerationPerStrideSum: Double, MinAccelerationPerStrideSum: Double, MaxAccelerationPerStride: Double, MinAccelerationPerStride: Double, GyroIntegral: Double, FrameCount: Double, NumberOfSteps: Double, TempoIntegral: Double, AverageTempo: Double, SignedTempoOffset:Double, AbsoluteTempoOffset:Double, OSDistance: Double) = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    
    /*
     AbsoluteAccelerationIntegral is the integral of absolute acceleration over the 100 meters
     AbsoluteAccelerationIntegralMinusG is the integral of the absolute acceleration, minus 1g*time
     AverageAbsoluteAccelerationIntegralPerStride is the average of the first per stride, so the first divided by the step count.
     AverageAbsoluteAccelerationIntegralPerStrideMinusG is the third minus 1g*time
     
     AbsoluteJerkIntegral is the integral of absolute jerk over the 100 meters
     AbsoluteJerkIntegralPerStride is the integral of absolute jerk per stride.
     
     AverageAbsoluteAccelerationIntegralPerStrideWeightedByLength is the integral of each stride, weighted by time and averaged for all the strides. Might be unfun to code
     
     MaxAccelerationPerStrideSum
     MinAccelerationPerStrideSum // to calculate below
     
     MaxAccelerationPerStride is the highest a recorded in each stride, averaged over the 100 meters
     MinAccelerationPerStride is the lowest a recorded in each stride, averaged over the 100 meters
     
     GyroIntegral is the integral of rotation rate, over the 100 meters
     
     FrameCount is the count of frames. += 1 every frame. Easiest to code lol
     NumberOfSteps is the number of steps, += 1 every frame. Second easiest to code lol
     
     TempoIntegral is an approximation of the Number of steps, a left Riemann Sum instead of a right Riemann sum. They'd be identical if the bounds were constant, which they almost are
     
     AverageTempo is the average tempo over the whole 100 meters, calculated at end
     
     SignedTempoOffset is how much total signed ofset there is between the tempo integral and actual step count. It's how much they sped up, so how much the NumberOfSteps is bigger then the integral
     AbsoluteTempoOffset is how much absolute ofset there is between the tempo integral and actual step count

     
     OSDistance is the integral of the OS's velocity. It's what we compare everything else to. It doesn't really matter which OS algorithm we use, we can use 1 and hope for no outliers
     

     
     
     
     By when they're calculated:
     
     Real time:
        AbsoluteAccelerationIntegral is the integral of absolute acceleration over the 100 meters
        AverageAbsoluteAccelerationIntegralPerStrideWeightedByLength is the integral of each stride, weighted by time and averaged for all the strides. Might be unfun to code
        MaxAccelerationPerStrideSum
        MinAccelerationPerStrideSum // to calculate below
        GyroIntegral is the integral of rotation rate, over the 100 meters
        FrameCount is the count of frames. += 1 every frame. Easiest to code lol
        NumberOfSteps is the number of steps, += 1 every frame. Second easiest to code lol
        TempoIntegral is an approximation of the Number of steps, a left Riemann Sum instead of a right Riemann sum. They'd be identical if the bounds were constant, which they almost are
        OSDistance is the integral of the OS's velocity. It's what we compare everything else to. It doesn't really matter which OS algorithm we use, we can use 1 and hope for no outliers
     
        SignedTempoOffset is how much total signed ofset there is between the tempo integral and actual step count. It's how much they sped up, so how much the NumberOfSteps is bigger then the integral
        AbsoluteTempoOffset is how much absolute ofset there is between the tempo integral and actual step count

     
     When done:
        AbsoluteAccelerationIntegralMinusG is the integral of the absolute acceleration, minus 1g*time
        AverageAbsoluteAccelerationIntegralPerStride is the average of the first per stride, so the first divided by the step count.
        AverageAbsoluteAccelerationIntegralPerStrideMinusG is the third minus 1g*time
        MaxAccelerationPerStride is the highest a recorded in each stride, averaged over the 100 meters
        MinAccelerationPerStride is the lowest a recorded in each stride, averaged over the 100 meters
        AverageTempo is the average tempo over the whole 100 meters, calculated at end
     */


    var body: some View {
        TabView {
            GPSDataDisplay(DisplayData: $Data)
                .tabItem {
                    Label("Collected Data", systemImage: "waveform.path.ecg.text.clipboard")
                }
            
            GPSDataCollecter(isCollectingData: $isRecording, CollectionNeedsToStop: $CollectionNeedsToEndCurrentPoint, tonePlayerMode: $tonePlayerMode)
                .tabItem {
                    Label("Take Point", systemImage: "figure.run")
                }
            GPSDataDescription()
                .tabItem {
                    Label("Data Description", systemImage: "apple.book.pages")
                }
        }
        .onReceive(timer) { _ in // This runs at 30 FPS. That can be changed in the timer variable declaration at the top in the TabBarController.
            // Data[1].AverageTempo += 12
            
            if (isRecording)
            {
                CurrentDataPoint.FrameCount += 1
                CurrentDataPoint.AbsoluteAccelerationIntegral += theMotionManager.accelerometerData.total * framerate
                CurrentDataPoint.TempoIntegral += (Double(theTempo)/60) * framerate // 1800 is the number of frames per minute
                CurrentDataPoint.GyroIntegral += theMotionManager.gyroscopeData.total * framerate
                CurrentDataPoint.OSDistance += theGPS.rawVelocity * framerate
                CurrentDataPoint.AbsoluteJerkIntegral += theMotionManager.accelerometerData.jerk * framerate
                
                //Offset
                
                CurrentStrideAccelerationIntegral += theMotionManager.accelerometerData.total * framerate
                
                if (StopAStride) {
                    CurrentDataPoint.NumberOfSteps += 1
                    
                    CurrentDataPoint.SignedTempoOffset += CurrentDataPoint.NumberOfSteps - CurrentDataPoint.TempoIntegral
                    CurrentDataPoint.AbsoluteTempoOffset += abs(CurrentDataPoint.NumberOfSteps - CurrentDataPoint.TempoIntegral)
                    CurrentDataPoint.MaxAccelerationPerStrideSum += HighAccelerationRecord
                    CurrentDataPoint.MinAccelerationPerStrideSum += LowAccelerationRecord
                    
                    AbsoluteAccelerationIntegralPerStrideWeightedByLength += CurrentStrideAccelerationIntegral/LastStrideLength
                    
                    StopAStride = false
                }
            }
            if (CollectionNeedsToEndCurrentPoint)
            {
                // it already adds the current data above
                
                
                //calculate the When Done stuff
                CurrentDataPoint.AbsoluteAccelerationIntegralMinusG = CurrentDataPoint.AbsoluteAccelerationIntegral - (9.81*CurrentDataPoint.FrameCount*framerate)
                CurrentDataPoint.AverageAbsoluteAccelerationIntegralPerStride = CurrentDataPoint.AbsoluteAccelerationIntegral / CurrentDataPoint.NumberOfSteps
                CurrentDataPoint.AverageAbsoluteAccelerationIntegralPerStrideMinusG = CurrentDataPoint.AbsoluteAccelerationIntegralMinusG / CurrentDataPoint.NumberOfSteps
                CurrentDataPoint.MaxAccelerationPerStride = CurrentDataPoint.MaxAccelerationPerStrideSum / CurrentDataPoint.NumberOfSteps
                CurrentDataPoint.MinAccelerationPerStride = CurrentDataPoint.MinAccelerationPerStrideSum / CurrentDataPoint.NumberOfSteps
                CurrentDataPoint.AverageTempo = CurrentDataPoint.NumberOfSteps / (CurrentDataPoint.FrameCount * (framerate / 60))// Number of steps over number of minutes //For some reason this is broken and returnes 1800 sometimes
                CurrentDataPoint.AbsoluteJerkIntegralPerStride = CurrentDataPoint.AbsoluteJerkIntegral / CurrentDataPoint.NumberOfSteps
                
                CurrentDataPoint.AverageAbsoluteAccelerationIntegralPerStrideWeightedByLength = AbsoluteAccelerationIntegralPerStrideWeightedByLength / CurrentDataPoint.NumberOfSteps
                
                //Append current data to the collected data
                Data.append(CurrentDataPoint)
                
                // Reset the collected data for next time
                CurrentDataPoint = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0) // reset everything
                AbsoluteAccelerationIntegralPerStrideWeightedByLength = 0
                
                // We're no longer collecting data
                CollectionNeedsToEndCurrentPoint = false
                isRecording = false
            }
            
            
        }
    }
}

#Preview {
    TabBarController()
}

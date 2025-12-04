//
//  Playlist.swift
//  MetroGnome
//
//  Created by Connor Kale on 10/26/25.
//

/*
 The following needs to be displayed:
     @Binding public var DisplayData: [(AbsoluteAccelerationIntegral: Double, AbsoluteAccelerationIntegralMinusG: Double, AverageAbsoluteAccelerationIntegralPerStride: Double, AverageAbsoluteAccelerationIntegralPerStrideMinusG: Double, AbsoluteJerkIntegral: Double, AbsoluteJerkIntegralPerStride: Double, AverageAbsoluteAccelerationIntegralPerStrideWeightedByLength: Double, MaxAccelerationPerStrideSum: Double, MinAccelerationPerStrideSum: Double, MaxAccelerationPerStride: Double, MinAccelerationPerStride: Double, GyroIntegral: Double, FrameCount: Double, NumberOfSteps: Double, TempoIntegral: Double, AverageTempo: Double, SignedTempoOffset:Double, AbsoluteTempoOffset:Double, OSDistance: Double)]
 
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
*/



import SwiftUI

struct GPSDataDescription: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("Description of data:")
                    .font(.system(size: 40))
                    .padding(.bottom, 60)

                Text("19 OSDistance")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The integral of the OS's velocity. How far the phone's GPS thinks I ran. To compare everything else to")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 60)

                
                Text("1 AbsoluteAccelerationIntegral")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The integral of absolute acceleration over the 100 meters")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)

                
                Text("2 AbsoluteAccelerationIntegralMinusG")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The integral of the absolute acceleration, like #1, but minus g*time")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)

                
                Text("3 AverageAbsoluteAccelerationIntegralPerStride")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The average of the acceleration integral per stride, so the first divided by the step count")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)

                
                Text("4 AverageAbsoluteAccelerationIntegralPerStrideMinusG")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("#3 minus 1g*time, like how #2 is #1-gt")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                    .padding(.bottom, 20)
                    .padding(.bottom, 20)


                Text("5 AbsoluteJerkIntegral")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The integral of absolute jerk over the 100 meters")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                Text("6 AbsoluteJerkIntegralPerStride")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The integral of absolute jerk per stride")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                
                    .padding(.bottom, 20)
                    .padding(.bottom, 20)


                Text("7 AverageAbsoluteAccelerationIntegralPerStrideWeightedByLength")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The integral of each stride, weighted by time and averaged for all the strides. Was slightly unfun to code")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)
                    .padding(.bottom, 20)

                
                Text("8 MaxAccelerationPerStrideSum")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("To calculate #10")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)

                
                Text("9 MinAccelerationPerStrideSum")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("To calculate #11")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)

                
                Text("10 MaxAccelerationPerStride")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The highest acceleration recorded in each stride, averaged over the 100 meters, or #8 divided by number of strides")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)

                
                Text("11 MinAccelerationPerStride")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The lowest acceleration recorded in each stride, averaged over the 100 meters, or #9 divided by number of strides")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)
                    .padding(.bottom, 20)

                
                Text("12 GyroIntegral")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The integral of rotation rate, over the 100 meters")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)
                    .padding(.bottom, 20)

                
                Text("13 FrameCount")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The count of frames. += 1 every frame. Framerate is 1/30 s. Easiest to code lol")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)

                
                Text("14 NumberOfSteps")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The number of steps, += 1 every step. Second easiest to code lol")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)

                
                Text("15 TempoIntegral")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("An approximation of the number of steps, a left Riemann Sum instead of a right Riemann sum. They'd be identical if the bounds were constant, which they almost are")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)

                
                Text("16 AverageTempo")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The average tempo over the whole 100 meters, calculated at end")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)
                    .padding(.bottom, 20)

                
                Text("17 SignedTempoOffset")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("How much total signed ofset there is between the tempo integral and actual step count. It's how much they sped up, so how much the NumberOfSteps is bigger then the integral")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)

                
                Text("18 AbsoluteTempoOffset")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("How much absolute ofset there is between the tempo integral and actual step count")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)
                    .padding(.bottom, 20)

                
                Text("19 OSDistance")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("The integral of the OS's velocity. How far the phone's GPS thinks I ran. To compare everything else to")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)
                    .padding(.bottom, 20)

                
                Text("1N TemplateDataTypeDescriptyion")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Blah blah blah")
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom, 20)

                
            }
            .padding(20) // This is for the edge margins
            .preferredColorScheme(.dark)
            .background(Color(red: (0.0/255.0), green: (100.0/255.0), blue: (100.0/255.0)))
        }
    }
}
//.background(Color(red: (0.0/255.0), green: (100.0/255.0), blue: (100.0/255.0)))

#Preview {
    GPSDataDescription()
}

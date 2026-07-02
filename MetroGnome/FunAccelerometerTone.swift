//
//  FunAccelerometerTone.swift
//  MetroGnome
//
//  Created by Connor Kale on 6/30/26.
//

import SwiftUI

struct FunAccelerometerTone: View {
    @Binding var tonePlayer: TonePlayer
    @ObservedObject var motionManager: MotionManager
    
    @State public var basePitch: Double = 0 // This is what plays if f(a)=1
    @State public var hideBasePitchMenu: Bool = true

    @State public var hideFunctionsMenu: Bool = true
    @State public var whichFunction: Int = 0 // 1 is linear, 2 is SQRT, 3 CBRT, 4 is power, 5 is log(1+), 6 is logBASE(1+), 7 is |log|, 8 is |logBASE|, 9 is arctan, 10 is tan, 11 is |sin|, 12 is 1+sin/12, 13 is weighted Sin
    @State public var power: Double = 1
    @State public var BASE: Double = 2.0
    @State public var sinWeight: Double = 1/12
    
    var body: some View {
        ScrollView {
            Text("This is REALLY old lol, from sophomore year")
            
            if (hideBasePitchMenu) {
                Button("Base Pitch")
                {
                    hideBasePitchMenu = false
                }
                .font(.system(size: 40))
            } else {
                Button("Base Pitch")
                {
                    hideBasePitchMenu = true
                }
                .font(.system(size: 40))

                Button("Off")
                {
                    basePitch = 0
                    tonePlayer.stop()
                }
                .font(.system(size: 40))
                
                
                Button("Base to 55")
                {
                    basePitch = 55
                    tonePlayer.start()
                }
                .font(.system(size: 40))
                
                Button("Base to 110")
                {
                    basePitch = 110
                    tonePlayer.start()
                }
                .font(.system(size: 40))
                
                Button("Base to 220")
                {
                    basePitch = 220
                    tonePlayer.start()
                }
                .font(.system(size: 40))
                
                Button("Base to 440")
                {
                    basePitch = 440
                    tonePlayer.start()
                }
                .font(.system(size: 40))
                
                Button("Base to 880")
                {
                    basePitch = 880
                    tonePlayer.start()
                }
                .font(.system(size: 40))
            }
            if (hideFunctionsMenu) {
                Button("Functions Menu")
                {
                    hideFunctionsMenu = false
                }
                .font(.system(size: 40))
            } else {
                Button("Functions Menu")
                {
                    hideFunctionsMenu = true
                }
                .font(.system(size: 40))
                
                // 1 is linear, 2 is SQRT, 3 CBRT, 4 is power, 5 is log(1+), 6 is logBASE(1+), 7 is |log|, 8 is |logBASE|, 9 is arctan, 10 is tan, 11 is |sin|, 12 is 1+sin/12, 13 is weighted Sin

                Button("Linear")
                {
                    whichFunction = 1
                }
                .font(.system(size: 40))
                Button("SQRT")
                {
                    whichFunction = 2
                }
                .font(.system(size: 40))
                Button("CBRT")
                {
                    whichFunction = 3
                }
                .font(.system(size: 40))
                Button("Power")
                {
                    whichFunction = 4
                }
                .font(.system(size: 40))
                
                HStack {
                    Text("Power is ")
                        .font(.system(size: 32))
                        .padding(.trailing, -100)
                    TextField("power", value: $power, format: .number)
                        .padding(.leading, 100)
                        .padding(.trailing, -20)
                        .font(.system(size: 32))
                }
                Slider(value: $power, in: -4...4, step: 0.1) // Min tempo slider
                    .padding(.horizontal)
                
                // 1 is linear, 2 is SQRT, 3 CBRT, 4 is power, 5 is log(1+), 6 is logBASE(1+), 7 is |log|, 8 is |logBASE|, 9 is arctan, 10 is tan, 11 is |sin|, 12 is 1+sin/12, 13 is weighted Sin
                Button("log(1+a)")
                {
                    whichFunction = 5
                }
                .font(.system(size: 40))
                Button("logBASE(1+a)")
                {
                    whichFunction = 6
                }
                .font(.system(size: 40))

                HStack {
                    Text("BASE is ")
                        .font(.system(size: 32))
                        .padding(.trailing, -100)
                    TextField("BASE", value: $BASE, format: .number)
                        .padding(.leading, 100)
                        .padding(.trailing, -20)
                        .font(.system(size: 32))
                }
                Slider(value: $BASE, in: 0.1...10, step: 0.1) // Min tempo slider
                    .padding(.horizontal)

                
                .font(.system(size: 40))
                Button("|log|")
                {
                    whichFunction = 7
                }
                .font(.system(size: 40))
                Button("|logBASE|")
                {
                    whichFunction = 8
                }
                .font(.system(size: 40))

                HStack {
                    Text("BASE is ")
                        .font(.system(size: 32))
                        .padding(.trailing, -100)
                    TextField("BASE", value: $BASE, format: .number)
                        .padding(.leading, 100)
                        .padding(.trailing, -20)
                        .font(.system(size: 32))
                }
                Slider(value: $BASE, in: 0.1...10, step: 0.1) // Min tempo slider
                    .padding(.horizontal)

                // 1 is linear, 2 is SQRT, 3 CBRT, 4 is power, 5 is log(1+), 6 is logBASE(1+), 7 is |log|, 8 is |logBASE|, 9 is arctan, 10 is tan, 11 is |sin|, 12 is 1+sin/12, 13 is weighted Sin

                .font(.system(size: 40))
                Button("arctan")
                {
                    whichFunction = 9
                }
                .font(.system(size: 40))
                Button("tan")
                {
                    whichFunction = 10
                }
                .font(.system(size: 40))
                Button("|sin|")
                {
                    whichFunction = 11
                }
                .font(.system(size: 40))
                Button("1+sin/12")
                {
                    whichFunction = 12
                }
                .font(.system(size: 40))
                Button("1+sin/weight")
                {
                    whichFunction = 13
                }
                .font(.system(size: 40))

                HStack {
                    Text("Weight is ")
                        .font(.system(size: 32))
                        .padding(.trailing, -100)
                    TextField("sinWeight", value: $sinWeight, format: .number)
                        .padding(.leading, 100)
                        .padding(.trailing, -20)
                        .font(.system(size: 32))
                }
                Slider(value: $sinWeight, in: 1...24, step: 1) // Min tempo slider
                    .padding(.horizontal)

                
            }
            
            Text("\(motionManager.accelerometerData.total, specifier: "%.3f")g")
                .font(.system(size: 80))
            Text("\(min(2000, (basePitch * motionManager.accelerometerData.total)), specifier: "%.3f") Hz")
                .font(.system(size: 80))
            Text("log(e)=\(log(2.718281828)) Hz")
                .font(.system(size: 80))

        }
        .onChange(of: motionManager.accelerometerData.total) { newTotal in
            // Update the pitch based on accelerometer data (total magnitude)
            var multiplier: Double = 1
            // 1 is linear, 2 is SQRT, 3 CBRT, 4 is power, 5 is log(1+), 6 is logBASE(1+), 7 is |log|, 8 is |logBASE|, 9 is arctan, 10 is tan, 11 is |sin|, 12 is 1+sin/12, 13 is weighted Sin
            switch (whichFunction) {
                case 1: multiplier = newTotal
                case 2: multiplier = sqrt(newTotal)
                case 3: multiplier = cbrt(newTotal)
                case 4: multiplier = pow(newTotal, power)
                case 5: multiplier = log(1+newTotal)
                case 6: multiplier = log(1+newTotal)/log(BASE)
                case 7: multiplier = abs(log(newTotal))
                case 8: multiplier = abs(log(newTotal)/log(BASE))
                case 9: multiplier = atan(newTotal)
                case 10: multiplier = tan(newTotal)
                case 11: multiplier = abs(sin(newTotal))
                case 12: multiplier = 1 + ((sin(newTotal))/12)
                case 13: multiplier = 1 + ((sin(newTotal))/sinWeight)
                default: multiplier = 1
            }
            tonePlayer.setFrequency(basePitch * multiplier)
        }
    }
}
/*
#Preview {
    FunAccelerometerTone()
}
*/

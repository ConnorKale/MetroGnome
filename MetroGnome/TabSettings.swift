//
//  Settings.swift
//  MetroGnome
//
//  Created by Connor Kale on 5/23/26.
//

import SwiftUI

struct SettingsTab: View {
    @AppStorage("MinTempo") private var MinTempo = DefaultSettings.MinTempo // BPM
    @AppStorage("TempoWindowSize") private var TempoWindowSize = DefaultSettings.TempoWindowSize // BPM, max equals min plus this. Go up to 60?
    
    @AppStorage("GoalPace") private var GoalPace = DefaultSettings.GoalPace // Meters per second
    @AppStorage("WhichPacingNotification") private var WhichPacingNotificaion = DefaultSettings.WhichPacingNotificaion // 1 is double, 2 is shepard, 3 is halfstep shepard
    
    
    @AppStorage("HelloWorldBool") private var HelloWorldBool = DefaultSettings.HelloWorldBool
    
    @AppStorage("ShowKilometers") private var ShowKilometers = DefaultSettings.ShowKilometers
    @AppStorage("ShowMiles") private var ShowMiles = DefaultSettings.ShowMiles
    @AppStorage("ShowMeters") private var ShowMeters = DefaultSettings.ShowMeters
    
    @AppStorage("TurnOffTempoMatching") private var TurnOffTempoMatching = DefaultSettings.TurnOffTempoMatching
    @AppStorage("AttemptSynchronization") private var AttemptSynchronization = DefaultSettings.AttemptSynchronization
    
    @Binding var needToResetGPS: Bool
    @State private var resetGPSFirstButton: Bool = false
    
    @AppStorage("ShowBigFontForTempo") private var ShowBigFontForTempo = DefaultSettings.ShowBigFontForTempo
    
    //@AppStorage("SongIndexMethod") private var SongIndexMethod = 1
    
    @AppStorage("SmoothGPS") private var SmoothGPS = DefaultSettings.SmoothGPS
    
    @AppStorage("ShowPlusOrMinus") private var ShowPlusOrMinus = DefaultSettings.ShowPlusOrMinus
    
    
    // Old was 13, 67, 67,
    // Dark teal is 025043 is 2, 80, 67; could contrast with ff0000
    // Light teal is 28a99e (40, 169, 158), could contrast with darker red?
    @AppStorage("MainRed") private var MainRed = DefaultSettings.MainRed
    @AppStorage("MainGreen") private var MainGreen = DefaultSettings.MainGreen
    @AppStorage("MainBlue") private var MainBlue = DefaultSettings.MainBlue
    
    @AppStorage("AccentRed") private var AccentRed = DefaultSettings.AccentRed
    @AppStorage("AccentGreen") private var AccentGreen = DefaultSettings.AccentGreen
    @AppStorage("AccentBlue") private var AccentBlue = DefaultSettings.AccentBlue
    @State private var ShowColorMenu: Bool = true
    
    
    // Show miles for pacing
    // Show kilometers for pacing
    // Show m/s
    var body: some View {
        TabView {
            ScrollView {
                HStack {
                    Button("-10")
                        {
                            MinTempo = max(MinTempo - 10, 120)
                        }
                        .font(.system(size: 28))
                        .padding(.horizontal)
                    Text("Min tempo:")
                        .font(.system(size: 28))
                        .padding(.trailing, -100)
                    TextField("Min tempo", value: $MinTempo, format: .number)
                        .padding(.leading, 100)
                        .padding(.trailing, -20)
                        .font(.system(size: 28))
                    Button("+10")
                        {
                            MinTempo = min(MinTempo + 10, (240-TempoWindowSize))
                        }
                        .font(.system(size: 28))
                        .padding(.horizontal)
                }
                Slider(value: $MinTempo, in: 120...max(130,(240-TempoWindowSize)), step: 10) // Min tempo slider
                    .onSubmit() {
                        MinTempo = round(MinTempo / 10) * 10
                    }
                    .padding(.horizontal, 30)

                Text("Max is \(String(Int(MinTempo + TempoWindowSize)))")
                    .font(.system(size: 28))

                HStack {
                    Button("-10")
                        {
                            TempoWindowSize = max(TempoWindowSize - 10, 0)
                        }
                        .font(.system(size: 28))
                        .padding(.horizontal)
                    Text("Tempo window:")
                        .font(.system(size: 28))
                        .padding(.trailing, -100)
                    TextField("Tempo Window Size", value: $TempoWindowSize, format: .number)
                        .padding(.leading, 100)
                        .padding(.trailing, -20)
                        .font(.system(size: 28))
                    Button("+10")
                        {
                            TempoWindowSize = min(TempoWindowSize + 10, 60)
                        }
                        .font(.system(size: 28))
                }
                Slider(value: $TempoWindowSize, in: 0...60, step: 10) // Min/max tempo slider
                    .onSubmit() {
                        TempoWindowSize = round(TempoWindowSize / 10) * 10
                        MinTempo = min(MinTempo, 240-TempoWindowSize)
                    }
                    .padding(.horizontal, 30)

                Text("If window is too big it won't work very well, I think 40 is best..?")
                    .font(.system(size: 26))
                    .padding(.horizontal)


                    .padding(.bottom, 100)

                
                Text("Goal pace stuff here I'm to tired to do nonmetric unit conversions rn")
                
                
                //.padding(.bottom, -10)

            }
            .background(Color(red: (MainRed/255.0), green: (MainGreen/255.0), blue: (MainBlue/255.0)))
            .tabItem {
                Label("Short-term", systemImage: "waveform.path.ecg.text.clipboard")
            }
            
            
            ScrollView { // Long-term start
                Toggle("Show kilometers", isOn: $ShowKilometers)
                    .font(.system(size: 32))
                Toggle("Show miles", isOn: $ShowMiles)
                    .font(.system(size: 32))
                Toggle("Show meters", isOn: $ShowMeters)
                    .font(.system(size: 32))
                    .padding(.bottom, 50)
                
                Toggle("Turn off tempo matching", isOn: $TurnOffTempoMatching)
                    .font(.system(size: 32))
                    .padding(.bottom, 10)
                    .onChange(of: TurnOffTempoMatching) { value in
                        if (TurnOffTempoMatching == false)
                        {
                            AttemptSynchronization = false
                        }
                    }
                if (TurnOffTempoMatching) {
                    Toggle("Schoolbus Party Mode :)", isOn: $AttemptSynchronization)
                        .font(.system(size: 32))
                }
                
                Toggle("Reset GPS?", isOn: $resetGPSFirstButton)
                    .padding(.top, 50)
                    .font(.system(size: 32))
                if (resetGPSFirstButton) {
                    Toggle("Are u sure or misclick?", isOn: $needToResetGPS)
                        .font(.system(size: 32))
                    Text("If you click yes, it won't say it did anything here, but it will reset")
                    Button("No") {
                        resetGPSFirstButton = false
                    }
                    .font(.system(size: 60))

                }
                
                Toggle("Big font for tempo", isOn: $ShowBigFontForTempo)
                    .font(.system(size: 32))
                    .padding(.bottom, 50)
                    .padding(.top, 50)

                /*Menu {
                 Button("As uploaded", action: { SongIndexMethod = 1 })
                 Button("Sorted", action: { SongIndexMethod = 2 })
                 } label: {
                 Label("Which song indexing method", systemImage: "chevron.down")
                 .padding()
                 .background(Color.blue.opacity(0.1))
                 .cornerRadius(8)
                 } */
                Toggle("Smooth GPS", isOn: $SmoothGPS)
                    .font(.system(size: 32))
                    .padding(.bottom, 50)
                Toggle("Show +/- 0.1", isOn: $ShowPlusOrMinus)
                    .font(.system(size: 32))
                    .padding(.bottom, 80)
                
                Button("Reset to defaults") {
                    MinTempo = DefaultSettings.MinTempo // BPM
                    TempoWindowSize = DefaultSettings.TempoWindowSize // BPM, max equals min plus this. Go up to 60?
                    
                    GoalPace = DefaultSettings.GoalPace // Meters per second
                    WhichPacingNotificaion = DefaultSettings.WhichPacingNotificaion // 1 is double, 2 is shepard, 3 is halfstep shepard
                    
                    
                    HelloWorldBool = DefaultSettings.HelloWorldBool
                    
                    ShowKilometers = DefaultSettings.ShowKilometers
                    ShowMiles = DefaultSettings.ShowMiles
                    ShowMeters = DefaultSettings.ShowMeters
                    
                    TurnOffTempoMatching = DefaultSettings.TurnOffTempoMatching
                    AttemptSynchronization = DefaultSettings.AttemptSynchronization

                    
                    ShowBigFontForTempo = DefaultSettings.ShowBigFontForTempo
                    
                    //@AppStorage("SongIndexMethod") private var SongIndexMethod = 1
                    
                    SmoothGPS = DefaultSettings.SmoothGPS
                    
                    ShowPlusOrMinus = DefaultSettings.ShowPlusOrMinus
                    
                    
                    MainRed = DefaultSettings.MainRed
                    MainGreen = DefaultSettings.MainGreen
                    MainBlue = DefaultSettings.MainBlue
                    
                    AccentRed = DefaultSettings.AccentRed
                    AccentGreen = DefaultSettings.AccentGreen
                    AccentBlue = DefaultSettings.AccentBlue

                }
                .font(.system(size: 32))
                .padding(.bottom, 80)

                if (ShowColorMenu) {
                    ZStack {
                        ButtonBackground(width: .constant(240), height: .constant(40), backgroundColor: .constant(Color(red: (MainRed/255.0), green: (MainGreen/255.0), blue: (MainBlue/255.0))))
                        HStack {
                            Button("Color settings       ")
                            {
                                ShowColorMenu = false
                            }
                            .font(.system(size: 28))
                            .padding(.trailing, -27)
                            Image(systemName: "swift")
                        }
                    }
                    
                    
                    Text("More asthetics coming up!")
                    Button("Reset background")
                    {
                        MainRed = 2
                        MainGreen = 80
                        MainBlue = 67
                    }
                    .font(.system(size: 32))
                    
                    HStack {
                        Text("Background red:")
                            .font(.system(size: 28))
                            .padding(.leading, 60)
                            .padding(.trailing, -100)
                        TextField("MainRed", value: $MainRed, format: .number)
                            .padding(.leading, 100)
                            .font(.system(size: 28))
                    }
                    Slider(value: $MainRed, in: 0...255, step: 1) // Min/max tempo slider
                        .onSubmit() {
                            MainRed = min(255, max(0, MainRed))
                        }
                        .padding(.horizontal, 30)
                    HStack {
                        Text("Background green:")
                            .font(.system(size: 28))
                            .padding(.leading, 60)
                            .padding(.trailing, -100)
                        TextField("MainGreen", value: $MainGreen, format: .number)
                            .padding(.leading, 100)
                            .font(.system(size: 28))
                    }
                    Slider(value: $MainGreen, in: 0...255, step: 1) // Min/max tempo slider
                        .onSubmit() {
                            MainGreen = min(255, max(0, MainGreen))
                        }
                        .padding(.horizontal, 30)
                    
                    
                    HStack {
                        Text("Background blue:")
                            .font(.system(size: 28))
                            .padding(.leading, 60)
                            .padding(.trailing, -100)
                        TextField("MainBlue", value: $MainBlue, format: .number)
                            .padding(.leading, 100)
                            .font(.system(size: 28))
                    }
                    Slider(value: $MainBlue, in: 0...255, step: 1) // Min/max tempo slider
                        .onSubmit() {
                            MainBlue = min(255, max(0, MainBlue))
                        }
                        .padding(.horizontal, 30)
                } else {
                    ZStack {
                        ButtonBackground(width: .constant(240), height: .constant(40), backgroundColor: .constant(Color(red: (MainRed/255.0), green: (MainGreen/255.0), blue: (MainBlue/255.0))))
                        HStack {
                            Button("Color settings       ")
                            {
                                ShowColorMenu = true
                            }
                            .font(.system(size: 28))
                            .padding(.trailing, -27)
                            Image(systemName: "swift")
                        }
                    }
                }

            }
            .background(Color(red: (MainRed/255.0), green: (MainGreen/255.0), blue: (MainBlue/255.0)))
            .tabItem {
                Label("Long-term", systemImage: "waveform.path.ecg.text.clipboard")
            }
        }
    }

    }

enum DefaultSettings {
    static let MinTempo = 160.0 // BPM
    static let TempoWindowSize = 40.0 // BPM, max equals min plus this. Go up to 60?
    
    static let GoalPace = 0.0 // Meters per second
    static let WhichPacingNotificaion = 1 // 1 is double, 2 is shepard, 3 is halfstep shepard
    
    
    static let HelloWorldBool = true
    
    static let ShowKilometers = true
    static let ShowMiles = true
    static let ShowMeters = true
    
    static let TurnOffTempoMatching = false
    static let AttemptSynchronization = false
    
    static let ShowBigFontForTempo = false
    
    // static let Framerate = 30.0 // FPS, I don't think this works with the timer initialization
    
    //@AppStorage("SongIndexMethod") private var SongIndexMethod = 1
    
    static let SmoothGPS = true
    
    static let ShowPlusOrMinus = true
    
    
    // Old was 13, 67, 67,
    // Dark teal is 025043 is 2, 80, 67; could contrast with ff0000
    // Light teal is 28a99e (40, 169, 158), could contrast with darker red?
    static let MainRed = 2.0
    static let MainGreen = 80.0
    static let MainBlue = 67.0
    
    static let AccentRed = 255.0
    static let AccentGreen = 0.0
    static let AccentBlue = 0.0
}
/*
#Preview {
    TabView {
        SettingsTab()
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        SettingsTab()
            .tabItem {
                Label("Settings", systemImage: "gear")
            }

    }
    //.background(Color(red: (Double(MainRed)/255.0), green: (Double(MainGreen)/255.0), blue: (Double(MainBlue)/255.0)))
    .background(Color(red: (DefaultSettings.MainRed/255.0), green: (DefaultSettings.MainGreen/255.0), blue: (DefaultSettings.MainBlue/255.0)))
}
*/

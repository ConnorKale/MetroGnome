//
//  ButtonsView.swift
//  MetroGnome
//
//  Created by Connor Kale on 10/26/25.
//

import SwiftUI

struct ButtonsView: View {
    @ObservedObject var theAudioPlayer: VariableSpeedAudioPlayer
    @ObservedObject var theShepardAudioPlayer: VariableSpeedAudioPlayer
    
    
    // Muffin has updated MP3's: true
    // School has updated MP3's: true
    
    
    // I'm going to let the ButtonsView manage the audio that's playing unless that causes problems. I don't think it will..?
    // Update file names array, tempos array, extensions array, number of songs, proofread
    // If uploaded twice, convention is slow, then fast; which means higher inputted tempo, then lower inputted tmepo
    public var numberOfSongs: Int = 33
    @State public var selectedSongIndex: Int = 0
    public var songNames: [String] = ["MetroGnomeTestAudio_256Measures", "MetroGnomeTestAudio_256Measures", "MetroGnomeShepard'sTone", "MetroGnomeHalfstepShepard'sTone", "KorobeinikiPiano150", "KorobeinikiPiano150", "KorobeinikiString152+", "KorobeinikiString152+", "CanonMusicBox120", "WikipediaCanon160BPM", "WikipediaCanon160BPM", /* If in-line comments don't break the compiler this is the end of the wav files */ "WikipediaCanon160BPMisMP3", "90s", "DontFearTheReaper", "PartyUSA", "PartyUSA", "PartyCIA", "PartyCIA", "CultOfPersonality92.5", "MotorcycleDriver160", "500Miles130", "SuperTrouper115", "LayAllYourLoveOnMe133", "Moskau121", "Moskau121", "DontStopTheMusic122.5", "DangerZone158", "FinalCountdown118Less", "WilliamTellOvertureFinale147", "Bolero68or76", "ForeverPiccolo120", "ForeverPiccolo120", "TheVeldt"]
    public var fileTempos: [Float] = [180.0, 90.0, 180.0, 180.0, 150.0, 75.0, 152.0, 76.0, 120.0, 160.0, 80.0, /* End of wavs */ 160.0, 158.0, 141.5, 192.0, 96.0, 192.0, 96.0, 185, 160, 130, 115, 133, 242, 121, 122.5, 158, 118, 147, 144, 240.0, 120.0, 180.0]
    public var fileExtensions: [String] = ["wav", "wav", "wav", "wav", "wav", "wav", "wav", "wav", "wav", "wav", "wav", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3", "mp3"]
    @Binding public var theCurrentlyPlayingFileTempo: Float // Maybe replace with something about the current song's index, so I can access it's other properties. Not now.
    
    @Binding var theUsedVelocity: Int // This is what velocity algorithm you're using and should be an ∈ of {1, 2, 3}.
    @Binding var theUsedPacingMethod: Int // 1 is doubling tempo, 2 is playing a beautiful shepards tone, 3 is extra beautiful shepards tone, 4 is stopping.
    
    @Binding var theGoalPaceKilometers: Double // This is in minutes per kilometer
    public var lowestGoalPaceKilometers: Double = 2.0 // This is in minutes per kilometer
    public var highestGoalPaceKilometers: Double = 10.0 // This is in minutes per kilometer

    @Binding var theGoalPaceMiles: Double // This is in minutes per mile
    public var lowestGoalPaceMiles: Double = 3.0
    public var highestGoalPaceMiles: Double = 16.0

    @Binding var theGoalVelocity: Double // Equals with 26.6666667/theGoalPace

    @Binding var theTempo: Float // In seconds

    @Binding var theMinTempo: Double
    @Binding var theMaxTempo: Double
    public var lowestMinTempo: Double = 120.0
    public var highestMinTempo: Double = 190.0
    // private var lowestMaxTempo: Double = 150.0
    // private var highestMaxTempo: Double = 220.0


    
    var body: some View {
        ScrollView {
            VStack {
                Text("Hello, World!")
                
                VStack(spacing: 20) {
                    Button(theAudioPlayer.isPlaying ? "Stop" : "Play") {
                        if theAudioPlayer.isPlaying {
                            theAudioPlayer.stop()
                            theShepardAudioPlayer.stop()
                        } else {
                            theCurrentlyPlayingFileTempo = fileTempos[Int(selectedSongIndex)]
                            theAudioPlayer.loadAndPlay(filename: songNames[Int(selectedSongIndex)], fileExtension: fileExtensions[Int(selectedSongIndex)]) // your file name
                        }
                    }
                    .font(.system(size: 100))
                    //.padding(.bottom, -30)

                    HStack {
                        Button("Prev")
                        {
                            selectedSongIndex = max(selectedSongIndex - 1, 0)
                        }
                        .font(.system(size: 24))
                        Text("Will play song number \(String(selectedSongIndex + 1)).")
                        Button("Next")
                        {
                            selectedSongIndex = min((selectedSongIndex + 1), (numberOfSongs - 1))
                        }
                        .font(.system(size: 24))

                    }
                    .padding(.bottom, -20)
                    
                    Slider(
                        value: Binding(
                            get: { Double(selectedSongIndex) },
                            set: { selectedSongIndex = Int($0) }
                        ),
                        in: 0...Double(numberOfSongs - 1),
                        step: 1
                    )
                    .padding(.horizontal)
                    .padding(.bottom, -20)
                }
                
                HStack { // Which Pacing method
                    Text("Pacing  \(String(Int(theUsedPacingMethod)))")
                    Button("Double")
                    {
                        theUsedPacingMethod = 1
                    }
                    Button("Shepard")
                    {
                        theUsedPacingMethod = 2
                    }
                    Button("Halfstep")
                    {
                        theUsedPacingMethod = 3
                    }
                    Button("Off")
                    {
                        theUsedPacingMethod = 4
                    }
                }

                Text("Tempo:")
                    .font(.system(size: 20))
                Text("\(theTempo, specifier: "%.2f")")
                    .font(.system(size: 80))
                    .padding(.bottom, -20)

                HStack { // Which Velocity
                    Text("GPS \(String(Int(theUsedVelocity)))")
                    Button("Use 1")
                    {
                        theUsedVelocity = 1
                    }
                    Button("Use 2")
                    {
                        theUsedVelocity = 2
                    }
                    Button("Off")
                    {
                        theUsedVelocity = 3
                    }
                }
                .padding(.bottom, 30)

                HStack {
                    Button("-10") // Min/max tempo text
                    {
                        theMinTempo = max(theMinTempo - 10, lowestMinTempo)
                    }
                    .font(.system(size: 40))
                    Text("Min tempo \(String(Int(theMinTempo))), max \(String(Int(theMaxTempo)))")
                    Button("+10")
                    {
                        theMinTempo = min(theMinTempo + 10, highestMinTempo)
                    }
                    .font(.system(size: 40))
                }
                //.padding(.bottom, -10)

                Slider(value: $theMinTempo, in: lowestMinTempo...highestMinTempo, step: 10) // Min/max tempo slider
                    .onChange(of: theMinTempo) { newValue in
                        theMinTempo = round(newValue / 10) * 10
                        theMaxTempo = theMinTempo + 40.0
                    }
                    .padding(.horizontal)
                    //.padding(.bottom, 30)

                HStack { // Goal pace text kilometers
                    Button("-10s")
                    {
                        theGoalPaceKilometers = max(theGoalPaceKilometers - (1.0/6.0), lowestGoalPaceKilometers)
                        theGoalPaceMiles = theGoalPaceKilometers * 1.6
                    }
                    .font(.system(size: 40))
                    Text("Goal pace is \(String(theGoalPaceKilometers)) min/km.")
                    Button("+10s")
                    {
                        theGoalPaceKilometers = min(theGoalPaceKilometers + (1.0/6.0), highestGoalPaceKilometers)
                        theGoalPaceMiles = theGoalPaceKilometers * 1.6
                    }
                    .font(.system(size: 40))
                }
                //.padding(.bottom, -10)
                
                Slider(value: $theGoalPaceKilometers, in: lowestGoalPaceKilometers...highestGoalPaceKilometers, step: (1.0/6.0)) // Goal pace slider
                    .onChange(of: theGoalPaceKilometers) { newValue in
                        theGoalPaceKilometers = round(newValue*6.0) / 6.0
                        theGoalVelocity = 16.6666667 / theGoalPaceKilometers
                        theGoalPaceMiles = theGoalPaceKilometers * 1.6
                    }
                    .padding(.horizontal)


                HStack { // Goal pace text miles
                    Button("-10s")
                    {
                        theGoalPaceMiles = max(theGoalPaceMiles - (1.0/6.0), lowestGoalPaceMiles)
                        theGoalPaceKilometers = theGoalPaceMiles / 1.6
                    }
                    .font(.system(size: 40))
                    Text("Goal pace is \(String(theGoalPaceMiles)) min/mi.")
                    Button("+10s")
                    {
                        theGoalPaceMiles = min(theGoalPaceMiles + (1.0/6.0), highestGoalPaceMiles)
                        theGoalPaceKilometers = theGoalPaceMiles / 1.6
                    }
                    .font(.system(size: 40))
                }
                //.padding(.bottom, -10)
                
                Slider(value: $theGoalPaceMiles, in: lowestGoalPaceMiles...highestGoalPaceMiles, step: (1.0/6.0)) // Goal pace slider
                    .onChange(of: theGoalPaceMiles) { newValue in
                        theGoalPaceMiles = round(newValue*6.0) / 6.0
                        theGoalVelocity = 26.6666667 / theGoalPaceMiles
                        theGoalPaceKilometers = theGoalPaceMiles / 1.6
                    }
                    .padding(.horizontal)




            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .preferredColorScheme(.dark)
            .background(Color(red: (57.0/256.0), green: (15.0/256.0), blue: (87.0/256.0)))
        }
    }
}

#Preview {
    TabBarController()
}

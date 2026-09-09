//
//  ButtonsView.swift
//  MetroGnome
//
//  Created by Connor Kale on 10/26/25.
//

import SwiftUI

struct OldButtonsView: View {
    @ObservedObject var theAudioPlayer: VariableSpeedAudioPlayerPausing
    @ObservedObject var theShepardAudioPlayer: VariableSpeedAudioPlayerPausing
    
    
    // Muffin has updated MP3's: true
    // School has updated MP3's: truw
    
    
    // I'm going to let the ButtonsView manage the audio that's playing unless that causes problems. I don't think it will..?
    // Update file names array, tempos array, extensions array, number of songs, proofread
    // If uploaded twice, the convention is slow, then fast; which means higher inputted tempo, then lower inputted tmepo
    
    // Be carefull with songs that are in 3 (or something else that's not a power of 2) or swingy
    //public var numberOfSongs: Int = 46
    
    @State private var songs: [Song] = []
    @State private var selectedSongIndex: Int = 0

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
    
    //@State private var songs: [Song] = loadSongs()

    
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
                            let currentSong = songs[selectedSongIndex]
                            theCurrentlyPlayingFileTempo = currentSong.tempo
                            theAudioPlayer.loadAndPlay(filename: currentSong.fileName, fileExtension: currentSong.fileExtension)
                            /*
                            theCurrentlyPlayingFileTempo = fileTempos[Int(selectedSongIndex)]
                            theAudioPlayer.loadAndPlay(filename: songNames[Int(selectedSongIndex)], fileExtension: fileExtensions[Int(selectedSongIndex)]) // file name
                             */
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
                        if (songs.count != 0) {
                            VStack {
                                Text("Will play song number \(String(selectedSongIndex + 1)) which is:")
                                Text("\(String(songs[selectedSongIndex].songName))")
                            }

                        }
                        Button("Next")
                        {
                            selectedSongIndex = min((selectedSongIndex + 1), (songs.count - 1))
                        }
                        .font(.system(size: 24))
                        
                    }
                    .padding(.bottom, 20)
                    
                    if (songs.count != 0) { // At the start (for the first frame I think) the JSON won't be loaded, and songs.count equals 0. If the slider tries to render with a range from 0 to -1, the whole app will crash :( The if statement is to stop that from happening, by not rendering the slider until songs.count isn't 0.
                        Slider(
                            value: Binding(
                                get: { Double(selectedSongIndex) },
                                set: { selectedSongIndex = Int($0) }
                            ),
                            in: 0...Double($songs.count - 1), //  I tried doing binding unwrappings on this line but I couldn't figure it out so I just put the whole slider in an if statement
                            step: 1
                        )
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
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
                    .padding(.bottom, 20)
                
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
            .background(Color(red: (57.0/255.0), green: (15.0/255.0), blue: (87.0/255.0)))
        }
        .onAppear {
            songs = loadSongs()
        }
    }
    
}
/* This is a redeclaration, after I made a copy of the script, which is why it's commented out
func loadSongs() -> [Song] {
    guard let url = Bundle.main.url(forResource: "songs", withExtension: "json") else {
        fatalError("songs.json not found")
    }

    do {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([Song].self, from: data)
    } catch {
        fatalError("Failed to load songs: \(error)")
    }
}*/


#Preview {
    TabBarController()
}


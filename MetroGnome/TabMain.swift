//
//  ButtonsView.swift
//  MetroGnome
//
//  Created by Connor Kale on 10/26/25.
//
import SwiftUI

struct MainTab: View {
    @ObservedObject var theAudioPlayer: VariableSpeedAudioPlayer
    @ObservedObject var theShepardAudioPlayer: VariableSpeedAudioPlayer
    
    
    // Muffin has updated MP3's: true
    // School has updated MP3's: true
    
    
    //@State private var songs: [Song] = []
    @State private var selectedSongIndex: Int = 0
    
    @Binding public var theCurrentlyPlayingFileTempo: Float // Maybe replace with something about the current song's index, so I can access it's other properties. Not now.
    //@Binding public var currentlyPlayingFileIndex: Int
    
    @Binding var tempoToDisplay: Float // BPM
    @Binding var velocity: Double // m/s
    @Binding var distanceIntegral: Double // m
    @AppStorage("ShowKilometers") private var ShowKilometers = DefaultSettings.ShowKilometers
    @AppStorage("ShowMiles") private var ShowMiles = DefaultSettings.ShowMiles
    @AppStorage("ShowMeters") private var ShowMeters = DefaultSettings.ShowMeters

    @AppStorage("ShowBigFontForTempo") private var ShowBigFontForTempo = DefaultSettings.ShowBigFontForTempo

    @Binding var offsetButtonMultiplier: Float
    
    @State private var songs: [Song] = loadSongs()
    
    @AppStorage("MainRed") private var MainRed = DefaultSettings.MainRed
    @AppStorage("MainGreen") private var MainGreen = DefaultSettings.MainGreen
    @AppStorage("MainBlue") private var MainBlue = DefaultSettings.MainBlue
    
    @AppStorage("AccentRed") private var AccentRed = DefaultSettings.AccentRed
    @AppStorage("AccentGreen") private var AccentGreen = DefaultSettings.AccentGreen
    @AppStorage("AccentBlue") private var AccentBlue = DefaultSettings.AccentBlue

    
    var body: some View {
        ScrollView {
            //Start of play button [
            Button(theAudioPlayer.isPlaying ? "Stop" : "Play") {
                if theAudioPlayer.isPlaying {
                    theAudioPlayer.stop()
                    theShepardAudioPlayer.stop()
                } else {
                    let currentSong = songs[selectedSongIndex]
                    theCurrentlyPlayingFileTempo = currentSong.tempo
                    theAudioPlayer.loadAndPlay(filename: currentSong.fileName, fileExtension: currentSong.fileExtension)
                }
            }
            .font(.system(size: 100))
            // End of play button ]
            
            
            // Start of song selecter [
            VStack {
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
            // End of song selector ]
            
            
            // Start of +/- 0.1 [
            VStack {
                Button("Ahead .1") {
                    offsetButtonMultiplier = 1.1
                }
                .font(.system(size: 105))
                Button("Back .1")
                {
                    offsetButtonMultiplier = 0.9
                }
                .font(.system(size: 100))
            }
            .font(.system(size: 120))
            .padding(.bottom, 70)
            // End of +/- 0.1 ]
            
            
            // Start of tempo^integrals info [
            VStack {
                if (ShowBigFontForTempo) {
                    Text("Tempo:")
                        .font(.system(size: 20))
                    Text("\(tempoToDisplay, specifier: "%.2f")")
                        .font(.system(size: 100))
                        .padding(.bottom, 20)
                } else {
                    Text("Tempo: \(tempoToDisplay, specifier: "%.2f")")
                        .font(.system(size: 50))
                        .padding(.bottom, 10)
                }
                Text("Distance run:")
                    .font(.system(size: 40))
                if (ShowKilometers) {
                    Text("∫ (km): \(distanceIntegral/1000, specifier: "%.2f")")
                        .font(.system(size: 30))
                        //.padding(.bottom, 10)
                }
                if (ShowMiles) {
                    Text("∫ (mi): \(distanceIntegral/1600, specifier: "%.2f")")
                        .font(.system(size: 30))
                        //.padding(.bottom, 10)
                }
                if (ShowMeters) {
                    Text("∫ (m): \(distanceIntegral, specifier: "%.2f")")
                        .font(.system(size: 30))
                        //.padding(.bottom, 10)
                }
                Text("Velocity:")
                    .font(.system(size: 40))
                    .padding(.top, 1)
                if (ShowKilometers) {
                    Text("v (kph): \(velocity*3.6, specifier: "%.2f")")
                        .font(.system(size: 30))
                        //.padding(.bottom, 10)
                }
                if (ShowMiles) {
                    Text("v (mph): \(velocity*2.25, specifier: "%.2f")")
                        .font(.system(size: 30))
                        //.padding(.bottom, 10)
                }
                if (ShowMeters) {
                    Text("v (m/s): \(velocity, specifier: "%.2f")")
                        .font(.system(size: 30))
                        //.padding(.bottom, 10)
                }
                
                Text("Pace:")
                    .font(.system(size: 40))
                    .padding(.top, 1)
                if (ShowKilometers) {
                    Text("P (min/km): \(16.6666667/velocity, specifier: "%.2f")")
                        .font(.system(size: 30))
                        //.padding(.bottom, 10)
                }
                if (ShowMiles) {
                    Text("P (min/mi): \(26.6666667/velocity, specifier: "%.2f")")
                        .font(.system(size: 30))
                        //.padding(.bottom, 10)
                }
                if (ShowMeters) {
                    Text("P (s/m): \(1/velocity, specifier: "%.2f")")
                        .font(.system(size: 30))
                        //.padding(.bottom, 10)
                }

                
            }
            // End of tempo^integrals info ]
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .preferredColorScheme(.dark)
        .background(Color(red: (MainRed/255.0), green: (MainGreen/255.0), blue: (MainBlue/255.0)))
    }
    /*.onAppear {
     songs = loadSongs()
     }*/
}

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
}


#Preview {
    TabBarController()
}

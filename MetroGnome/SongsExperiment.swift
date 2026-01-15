//
//  SongsExperiment.swift
//  MetroGnome
//
//  Created by Connor Kale on 1/15/26.
//

struct Song: Codable, Equatable {
    let name: String
    let tempo: Float
    let fileExtension: String
}



final class SongLibrary {

    private(set) var songs: [Song] = []

    init() {
        loadInitialData()
    }

    private func loadInitialData() {
        songs = [

            // WAV FILES
            Song(name: "MetroGnomeTestAudio_256Measures", tempo: 180, fileExtension: "wav"),
            Song(name: "MetroGnomeTestAudio_256Measures", tempo: 90, fileExtension: "wav"),
            Song(name: "MetroGnomeShepard'sTone", tempo: 180, fileExtension: "wav"),
            Song(name: "MetroGnomeHalfstepShepard'sTone", tempo: 180, fileExtension: "wav"),
            Song(name: "KorobeinikiPiano150", tempo: 150, fileExtension: "wav"),
            Song(name: "KorobeinikiPiano150", tempo: 75, fileExtension: "wav"),
            Song(name: "KorobeinikiString152+", tempo: 152, fileExtension: "wav"),
            Song(name: "KorobeinikiString152+", tempo: 76, fileExtension: "wav"),
            Song(name: "CanonMusicBox120", tempo: 120, fileExtension: "wav"),
            Song(name: "WikipediaCanon160BPM", tempo: 160, fileExtension: "wav"),
            Song(name: "WikipediaCanon160BPM", tempo: 80, fileExtension: "wav"),

            // MP3 FILES
            Song(name: "WikipediaCanon160BPMisMP3", tempo: 160, fileExtension: "mp3"),
            Song(name: "90s", tempo: 158, fileExtension: "mp3"),
            Song(name: "DontFearTheReaper", tempo: 141, fileExtension: "mp3"),
            Song(name: "PartyUSA", tempo: 192, fileExtension: "mp3"),
            Song(name: "PartyUSA", tempo: 96, fileExtension: "mp3"),
            Song(name: "PartyCIA", tempo: 192, fileExtension: "mp3"),
            Song(name: "PartyCIA", tempo: 96, fileExtension: "mp3"),
            Song(name: "CultOfPersonality92.5", tempo: 185, fileExtension: "mp3"),
            Song(name: "MotorcycleDriver160", tempo: 160, fileExtension: "mp3"),
            Song(name: "500Miles130", tempo: 130, fileExtension: "mp3"),
            Song(name: "SuperTrouper115", tempo: 115, fileExtension: "mp3"),
            Song(name: "LayAllYourLoveOnMe133", tempo: 133, fileExtension: "mp3"),
            Song(name: "Moskau121", tempo: 242, fileExtension: "mp3"),
            Song(name: "Moskau121", tempo: 121, fileExtension: "mp3"),
            Song(name: "DontStopTheMusic122.5", tempo: 122.5, fileExtension: "mp3"),
            Song(name: "DangerZone158", tempo: 158, fileExtension: "mp3"),
            Song(name: "FinalCountdown118Less", tempo: 118, fileExtension: "mp3"),
            Song(name: "WilliamTellOvertureFinale147", tempo: 147, fileExtension: "mp3"),
            Song(name: "Bolero68or76", tempo: 144, fileExtension: "mp3"),
            Song(name: "SmellsLikeCalculus120", tempo: 240, fileExtension: "mp3"),
            Song(name: "SmellsLikeCalculus120", tempo: 120, fileExtension: "mp3"),
            Song(name: "ForeverPiccolo120", tempo: 240, fileExtension: "mp3"),
            Song(name: "ForeverPiccolo120", tempo: 120, fileExtension: "mp3"),
            Song(name: "TheVeldt", tempo: 180, fileExtension: "mp3"),
            Song(name: "BrandenburgConcertoNo3Movement1at98", tempo: 196, fileExtension: "mp3"),
            Song(name: "SymphonyNo7inAMajorOp92Allegretto64", tempo: 192, fileExtension: "mp3"),
            Song(name: "TheSoundsOfSilence107", tempo: 214, fileExtension: "mp3"),
            Song(name: "TheSoundsOfSilence107", tempo: 107, fileExtension: "mp3"),
            Song(name: "DvorakSymphonyNo9at120", tempo: 240, fileExtension: "mp3"),
            Song(name: "DvorakSymphonyNo9at120", tempo: 120, fileExtension: "mp3"),
            Song(name: "MarsTheBringerOfWar150", tempo: 150, fileExtension: "mp3"),
            Song(name: "BananaBoat122", tempo: 244, fileExtension: "mp3"),
            Song(name: "BananaBoat122", tempo: 122, fileExtension: "mp3"),
            Song(name: "TakeAChanceOnMe106", tempo: 212, fileExtension: "mp3"),
            Song(name: "ZeldaFromMarioKart187", tempo: 187, fileExtension: "mp3")
        ]
    }
}





extension SongLibrary {

    func addSong(_ song: Song) {
        songs.append(song)
    }

    func song(at index: Int) -> Song? {
        songs.indices.contains(index) ? songs[index] : nil
    }

    func songs(named name: String) -> [Song] {
        songs.filter { $0.name == name }
    }

    func songs(withTempo tempo: Float) -> [Song] {
        songs.filter { $0.tempo == tempo }
    }

    func songs(withExtension ext: String) -> [Song] {
        songs.filter { $0.fileExtension == ext }
    }
}




let library = SongLibrary()

let wavSongs = library.songs(withExtension: "wav")
let partyUSA = library.songs(named: "PartyUSA")
let fastSongs = library.songs.filter { $0.tempo >= 180 }

library.addSong(
    Song(name: "NewSong", tempo: 128, fileExtension: "mp3")
)











func song(at index: Int) -> Song? {
    guard songs.indices.contains(index) else { return nil }
    return songs[index]
}


func songs(named name: String) -> [Song] {
    songs.filter { $0.name == name }
}


func songs(withTempo tempo: Float) -> [Song] {
    songs.filter { $0.tempo == tempo }
}


func songs(withExtension ext: String) -> [Song] {
    songs.filter { $0.fileExtension == ext }
}



let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

let jsonData = try encoder.encode(songLibrary.songs)
let jsonString = String(data: jsonData, encoding: .utf8)




let decoder = JSONDecoder()
let decodedSongs = try decoder.decode([Song].self, from: jsonData)

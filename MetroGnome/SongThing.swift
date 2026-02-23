//
//  SongThing.swift
//  MetroGnome
//
//  Created by Connor Kale on 2/2/26.
//

import Foundation // idk if this is necessary

struct Song: Identifiable, Codable {
    let id: Int // maybe UUID instead? // Each song's "number"
    let fileName: String //The file path/name
    let songName: String // The user-facing name, could appear in the ButtonsView
    let tempo: Float // The tempo. A faster tempo means it will play slower, enter half the actual tempo to make it play at double time
    let fileExtension: String // To decide whether to use the MP3 decoder or not
    let artist: String // The musician/composer
    let description: String // Optional description, or just ""
}

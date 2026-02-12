//
//  SongThing.swift
//  MetroGnome
//
//  Created by Connor Kale on 2/2/26.
//

import Foundation // idk if this is necessary

struct Song: Identifiable, Codable {
    let id: Int // maybe UUID instead?
    let name: String
    let tempo: Float
    let fileExtension: String
}

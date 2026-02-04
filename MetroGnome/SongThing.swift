//
//  SongThing.swift
//  MetroGnome
//
//  Created by Connor Kale on 2/2/26.
//
struct Song: Identifiable, Codable {
    let id: UUID
    let name: String
    let tempo: Float
    let fileExtension: String
}

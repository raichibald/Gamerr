//
//  Game.swift
//  GamerApp
//
//  Created by Raitis Saripo on 16/02/2021.
//

import Foundation

struct Game: Codable {
    let name: String?
    let released: String?
    let background_image: String?
    let rating: Double?
}

struct GamesList: Codable {
    let next: String?
    let results: [Game]
}

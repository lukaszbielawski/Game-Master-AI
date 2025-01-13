//
//  BoardGame.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 11/01/2025.
//

import Foundation

struct BoardGame: Codable {
    let gameId: Int
    let name: String
    let description: String
    let minPlayers: Int
    let maxPlayers: Int
    let playingTime: Int
    let usersRated: Int
}

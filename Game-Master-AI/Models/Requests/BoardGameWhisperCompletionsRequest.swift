//
//  BoardGameWhisperCompletionsRequest.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 21/02/2025.
//

import Foundation

public struct BoardGameWhisperCompletionsRequest: Codable, Sendable {
    let boardGameId: UUID
    let base64AudioM4A: String
}

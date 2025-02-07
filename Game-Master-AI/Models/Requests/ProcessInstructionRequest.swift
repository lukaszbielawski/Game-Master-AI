//
//  ProcessInstructionRequest.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 06/02/2025.
//

import Foundation

struct ProcessInstructionRequest: Codable, Sendable {
    let boardGameName: String
    let base64Images: [String]
}

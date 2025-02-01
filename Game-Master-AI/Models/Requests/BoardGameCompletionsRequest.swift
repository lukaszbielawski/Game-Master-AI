//
//  CompletionRequest.swift
//
//
//  Created by Łukasz Bielawski on 08/01/2025.
//

import Foundation

public struct BoardGameCompletionsRequest: Codable, Sendable {
    let boardGameId: UUID
    let userQuery: String
}

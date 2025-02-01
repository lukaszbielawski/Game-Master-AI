//
//  BoardGameModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 23/01/2025.
//

import Essentials
import Foundation

struct BoardGameModel: Identifiable, Hashable, ExpressibleByEssentialsSubject {
    var id: UUID { subjectId }
    let subjectId: UUID
    let sessionId: UUID
    let name: String
    let creationTimestamp: Int64

    init(_ subject: Essentials.SubjectDTO) {
        self.subjectId = subject.subjectId
        self.sessionId = subject.sessionId
        self.name = subject.name
        self.creationTimestamp = subject.timestamp
    }
}

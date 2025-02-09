//
//  TierType.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 08/02/2025.
//

import Essentials

enum TierType: EssentialsTierProtocol {
    var tierValue: Int {
        switch self {
        case .freeUsesMessages:
            0
        case .dailyLimitMessages:
            1
        case .monthlyLimitMessages:
            2
        case .monthlyLimitNewGames:
            3
        case .freeUsesNewGames:
            4
        }
    }

    init?(tierValue: Int) {
        switch tierValue {
        case 0:
            self = .freeUsesMessages
        case 1:
            self = .dailyLimitMessages
        case 2:
            self = .monthlyLimitMessages
        case 3:
            self = .monthlyLimitNewGames
        case 4:
            self = .freeUsesNewGames
        default:
            return nil
        }
    }

    case freeUsesMessages
    case dailyLimitMessages
    case monthlyLimitMessages
    case monthlyLimitNewGames
    case freeUsesNewGames
}

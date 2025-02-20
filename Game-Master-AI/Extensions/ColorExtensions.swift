//
//  ColorExtensions.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 20/02/2025.
//

import SwiftUI

extension Color: Codable {
    private struct RGBA: Codable {
        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rgba = try container.decode(RGBA.self)
        self = Color(red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }

    public func encode(to encoder: any Encoder) throws {
        guard let components = UIColor(self).cgColor.components else {
            throw EncodingError.invalidValue(self, EncodingError.Context(
                codingPath: encoder.codingPath,
                debugDescription: "Unable to extract color components."
            ))
        }

        let rgba = RGBA(
            red: components[0],
            green: components.count > 2 ? components[1] : components[0],
            blue: components.count > 2 ? components[2] : components[0],
            alpha: components.count > 3 ? components[3] : 1.0
        )

        var container = encoder.singleValueContainer()
        try container.encode(rgba)
    }
}

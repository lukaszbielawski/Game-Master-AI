//
//  ArrayExtensions.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 12/01/2025.
//

import Foundation

extension Array {
    func shift(n: Int) -> Self where Element == Int {
        var outputArray: [Int] = Array(repeating: 0, count: self.count)
        for (index, elem) in self.enumerated() {
            outputArray[(index - n + self.count) % self.count] = elem
        }
        return outputArray
    }
}

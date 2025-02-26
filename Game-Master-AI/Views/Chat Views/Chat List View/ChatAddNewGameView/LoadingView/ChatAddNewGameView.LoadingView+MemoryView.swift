//
//  LoadingView+MemoryView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 05/02/2025.
//

import SwiftUI
import Essentials

extension ChatAddNewGameView.LoadingView {
    struct MemoryView: View {
        @State private var gridItems = Array(repeating: GridItem(.flexible(), spacing: 8.0), count: 4)
        
        let emojis: [Character] = ["🎲", "♟️", "🧩", "🃏", "🏰", "🏆", "🧸", "🔮"]
        @State private var revaledIndices = Set<Int>()
        @State private var firstPickIndex: Int? = nil
        @State private var secondPickIndex: Int? = nil
        
        @State private var currentEmojiLayout: [Character] = []
        
        var body: some View {
            GeometryReader { _ in
                LazyVGrid(columns: gridItems, spacing: 8.0) {
                    ForEach(0 ..< 16) { index in
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.accentColor)
                                .aspectRatio(1, contentMode: .fill)
                            if firstPickIndex == index || secondPickIndex == index {
                                Text(String(currentEmojiLayout[index]))
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                        .opacity(revaledIndices.contains(index) ? 0.0 : 1.0)
                        .animation(.easeInOut(duration: 0.35), value: revaledIndices.contains(index))
                        .onTapGesture {
                            pick(index)
                        }
                    }
                }
            }
            .padding(.horizontal, 56)
            .padding(.vertical, 16)
            .onAppear {
                currentEmojiLayout = generateEmojiPositions()
            }
        }
        
        private func pick(_ index: Int) {
            guard secondPickIndex == nil else { return }
            if let firstPickIndex {
                guard firstPickIndex != index else { return }
                secondPickIndex = index
                EssentialsHapticService.shared.play(.medium)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if currentEmojiLayout[firstPickIndex] == currentEmojiLayout[index] {
                        revaledIndices.insert(firstPickIndex)
                        revaledIndices.insert(index)
                        if revaledIndices.count == 16 {
                            revaledIndices.removeAll()
                            currentEmojiLayout = generateEmojiPositions()
                        }
                    }
                    self.firstPickIndex = nil
                    self.secondPickIndex = nil
                }
            } else {
                firstPickIndex = index
                EssentialsHapticService.shared.play(.medium)
            }
        }
        
        private func generateEmojiPositions() -> [Character] {
            return (emojis + emojis).shuffled()
        }
    }
}

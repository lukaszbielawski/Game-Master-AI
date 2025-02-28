//
//  CounterViewListCell.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 28/02/2025.
//

import Essentials
import SwiftUI

extension CountersView {
    struct CounterViewListCell: View {
        @Binding var model: Model
        
        let cellHeight: CGFloat = 72.0
        
        var counterDigits: Int {
            let defaultPadding: Int = if model.count < 0 {
                2
            } else {
                1
            }
            
            guard abs(model.count) > 1 else { return defaultPadding }
            return Int(floor(log10(abs(Double(model.count))))) + defaultPadding
        }
        
        var body: some View {
            HStack(spacing: 8.0) {
                Button {
                    withAnimation {
                        EssentialsHapticService.shared.play(.light)
                        model.count -= 1
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                Text(String(model.count))
                    .font(.title)
                    .fontWeight(.semibold)
                    .animation(nil, value: model.count)
                    .frame(width: min(5, CGFloat(counterDigits)) * 20)
                Button {
                    withAnimation {
                        EssentialsHapticService.shared.play(.light)
                        model.count += 1
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                Text(model.name)
                    .font(.title3)
                    .padding(.trailing, 36)
                model.color
                    .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 16.0, bottomLeading: 16.0, bottomTrailing: 0.0, topTrailing: 0.0)))
                    .frame(width: cellHeight)
            }
            .frame(height: cellHeight)
            .padding(.leading, 16.0)
        }
    }
}

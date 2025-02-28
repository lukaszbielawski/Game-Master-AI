//
//  TimersView+TimerViewListCell.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 28/02/2025.
//

import Essentials
import SwiftUI

extension TimersView {
    struct TimerViewListCell: View {
        @EnvironmentObject var vm: TimersViewModel

        @Binding var model: Model

        let cellHeight: CGFloat = 72.0

        var remainingSeconds: Int {
            vm.getRemainingSeconds(model)
        }

        var displayedTime: String {
            var remainingTime = remainingSeconds
            let hours = remainingTime / 3600
            remainingTime -= hours * 3600
            let minutes = remainingTime / 60
            remainingTime -= minutes * 60
            let seconds = remainingTime
            if hours > 0 {
                return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            } else {
                return String(format: "%02d:%02d", minutes, seconds)
            }
        }

        var isPaused: Bool {
            vm.isPaused(model)
        }

        var isLaunched: Bool {
            vm.isLaunched(model)
        }

        var timerColor: Color {
            guard !isPaused && isLaunched else { return .tintColor }
            let remainingSeconds = self.remainingSeconds

            if remainingSeconds == 0 {
                return .successColor
            } else if remainingSeconds < 5 {
                return .failureColor
            } else if remainingSeconds < 10 {
                return .orange
            } else if remainingSeconds < 30 {
                return .yellow
            } else {
                return .tintColor
            }
        }

        var body: some View {
            HStack(spacing: 8.0) {
                Text(displayedTime)
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .foregroundStyle(timerColor)
                    .onChange(of: remainingSeconds) { newValue in
                        guard newValue == 0 else { return }
                        EssentialsHapticService.shared.notify(.success)
                    }
                    .opacity(0.7)
                Spacer()
                Button {
                    EssentialsHapticService.shared.play(.light)
                    if remainingSeconds == 0 {
                        vm.resetTimer(model)
                    } else if isPaused {
                        vm.resumeTimer(model)
                    } else if isLaunched {
                        vm.pauseTimer(model)
                    } else {
                        vm.launchTimer(model)
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.accentColor)
                        Image(systemName: isPaused || !isLaunched ? "play.fill" : "pause.fill")
                            .blendMode(.destinationOut)
                    }.compositingGroup()
                }
                .buttonStyle(PlainButtonStyle())
                .padding(4.0)

                Button {
                    EssentialsHapticService.shared.play(.light)
                    vm.resetTimer(model)
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.accentColor)
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title)
                            .fontWeight(.semibold)
                            .blendMode(.destinationOut)
                    }.compositingGroup()
                }
                .buttonStyle(PlainButtonStyle())
                .padding(4.0)
            }
            .frame(height: cellHeight)
            .padding(.horizontal, 24.0)
        }
    }
}

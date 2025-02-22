//
//  TimersView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 20/02/2025.
//

import Essentials
import SwiftUI

typealias TimerModel = TimersView.Model

struct TimersView: View {
    @StateObject var vm: TimersViewModel = .init()
    @ObservedObject var tabRouter = TabRouterState.shared
    @ObservedObject var router = RouterState.shared
    @Environment(\.colorScheme) var colorScheme

    @State private var isInEditMode = false

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0.0) {
                Divider()
                TimerPickerView(geo: geo)
                    .padding(.top, 16)
                Button {
                    EssentialsHapticService.shared.play(.light)
                    vm.createTimer()
                } label: {
                    Text("Start new timer")
                }
                .buttonStyle(EssentialsButtonStyle())
                .disabled(vm.pickerDurationSeconds == 0)
                .animation(.easeInOut(duration: 0.35), value: vm.pickerDurationSeconds)

                ScrollView(showsIndicators: false) {
                    ForEach(Array($vm.timers.enumerated()), id: \.0) { index, $timer in
                        Divider()
                        TimerViewListCell(model: $timer, isInEditMode: isInEditMode) { timerToDelete in
                            vm.deleteTimer(timerToDelete)
                        }
                        if index == vm.timers.count - 1 {
                            Divider()
                        }
                    }
                }
                Spacer()
            }
            .onAppear {
                tabRouter.currentToolbarRoute = .timers(isInEditMode: $isInEditMode) {
                    withAnimation {
                        isInEditMode.toggle()
                    }
                }
            }
        }
        .environmentObject(vm)
    }
}

extension TimersView {
    struct Model: Hashable, Codable, Identifiable {
        var id: UUID = .init()
        var initialDurationSeconds: Int
    }

    struct TimerViewListCell: View {
        @EnvironmentObject var vm: TimersViewModel

        @Binding var model: Model
        let isInEditMode: Bool

        let onDelete: (Model) -> Void

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
                .padding(4.0)

                if isInEditMode {
                    Button {
                        EssentialsHapticService.shared.play(.medium)
                        vm.deleteTimer(model)
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.failureColor)
                            Image(systemName: "trash.fill")
                                .font(.title)
                                .fontWeight(.semibold)
                                .blendMode(.destinationOut)
                        }.compositingGroup()
                    }
                    .padding(4.0)
                    .transition(.moveToTrailingAsymmetric.combined(with: .scale(scale: 0.0, anchor: .trailing)))
                } else {
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
                    .padding(4.0)
                    .transition(.moveToTrailingAsymmetric.combined(with: .scale(scale: 0.0, anchor: .trailing)))
                }
            }
            .frame(height: cellHeight)
            .padding(.horizontal, 24.0)
        }
    }

    struct TimerPickerView: View {
        @EnvironmentObject var vm: TimersViewModel
        let geo: GeometryProxy
        let hoursRange = Array(0...23)
        let minutesAndSecondsRange = Array(0...59)

        var body: some View {
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    Picker("Hours", selection: $vm.pickerHours) {
                        ForEach(hoursRange, id: \.self) { hour in
                            Text("\(hour)h")
                                .tag(hour)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: min(geo.size.width * 0.3, 100), height: 150)
                    .onChange(of: vm.pickerHours) { _ in
                        EssentialsHapticService.shared.play(.light)
                    }

                    Picker("Minutes", selection: $vm.pickerMinutes) {
                        ForEach(minutesAndSecondsRange, id: \.self) { minute in
                            Text("\(minute)m")
                                .tag(minute)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: min(geo.size.width * 0.3, 100), height: 150)
                    .onChange(of: vm.pickerMinutes) { _ in
                        EssentialsHapticService.shared.play(.light)
                    }

                    Picker("Seconds", selection: $vm.pickerSeconds) {
                        ForEach(minutesAndSecondsRange, id: \.self) { second in
                            Text("\(second)s")
                                .tag(second)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: min(geo.size.width * 0.3, 100), height: 150)
                    .onChange(of: vm.pickerSeconds) { _ in
                        EssentialsHapticService.shared.play(.light)
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
}

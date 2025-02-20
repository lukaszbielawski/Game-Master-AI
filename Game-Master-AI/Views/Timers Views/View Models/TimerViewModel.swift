//
//  TimerViewModel.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 20/02/2025.
//

import Combine
import Essentials
import SwiftUI

@MainActor
final class TimerViewModel: ObservableObject {
    @Published var timers: [TimerModel] = [] {
        willSet {
            Task { @MainActor in
                timersStorage = newValue
            }
        }
    }

    @EssentialsAppStorage("timers") private var timersStorage: [TimerModel]?

    @Published var pickerHours: Int = 0
    @Published var pickerMinutes: Int = 5
    @Published var pickerSeconds: Int = 0

    @Published var launchedTimersDict: [TimerModel: Date] = [:]
    @Published var pausedTimersDict: [TimerModel: TimeInterval] = [:]

    private var subscription: AnyCancellable?

    var pickerDurationSeconds: Int {
        pickerHours * 3600 + pickerMinutes * 60 + pickerSeconds
    }

    init() {
        self.timers = timersStorage ?? []
        setupSubscriptionIfNotPresent()
    }

    let router = RouterState.shared

    func createTimer() {
        let newTimer = TimerModel(initialDurationSeconds: pickerDurationSeconds)
        timers.append(newTimer)
        launchedTimersDict[newTimer] = Date.now.advanced(by: TimeInterval(newTimer.initialDurationSeconds))
    }

    private func setupSubscriptionIfNotPresent() {
        if subscription == nil {
            subscription = Timer.publish(every: 0.2, on: .current, in: .default)
                .autoconnect()
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
        }
    }

    func getRemainingSeconds(_ timer: TimerModel) -> Int {
        let remainingSeconds = if let pausedTimerTimeInteval = pausedTimersDict[timer] {
            max(0, Int(pausedTimerTimeInteval.rounded(.up)))
        } else {
            max(0, Int(launchedTimersDict[
                timer,
                default: Date.now.advanced(by: TimeInterval(timer.initialDurationSeconds))
            ].timeIntervalSinceNow.rounded(.up)))
        }
        if remainingSeconds == 0 {
            deactivateTimer(timer)
        }
        return remainingSeconds
    }

    private func deactivateTimer(_ timer: TimerModel) {
        pausedTimersDict[timer] = nil
        launchedTimersDict[timer] = nil
    }

    func launchTimer(_ timer: TimerModel) {
        pausedTimersDict[timer] = nil
        launchedTimersDict[timer] = Date.now.advanced(by: TimeInterval(timer.initialDurationSeconds))
    }

    func resumeTimer(_ timer: TimerModel) {
        let newAdvance = pausedTimersDict[timer, default: TimeInterval(timer.initialDurationSeconds)]
        pausedTimersDict[timer] = nil
        launchedTimersDict[timer] = Date.now.advanced(by: newAdvance)
    }

    func pauseTimer(_ timer: TimerModel) {
        pausedTimersDict[timer] = launchedTimersDict[timer]?.timeIntervalSinceNow ?? TimeInterval(timer.initialDurationSeconds)
    }

    func isPaused(_ timer: TimerModel) -> Bool {
        return pausedTimersDict[timer] != nil
    }

    func isLaunched(_ timer: TimerModel) -> Bool {
        return launchedTimersDict[timer] != nil
    }

    func deleteTimer(_ model: TimerModel) {
        if let indexToRemove = timers.firstIndex(where: { $0.id == model.id }) {
            timers.remove(at: indexToRemove)
        }
    }
}

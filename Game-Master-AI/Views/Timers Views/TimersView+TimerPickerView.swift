//
//  TimersView+TimerPickerView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 28/02/2025.
//

import Essentials
import SwiftUI

extension TimersView {
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

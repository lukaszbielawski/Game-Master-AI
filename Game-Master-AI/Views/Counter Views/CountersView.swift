//
//  CountersView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 20/02/2025.
//

import Essentials
import SwiftUI

typealias CounterModel = CountersView.Model

struct CountersView: View {
    @StateObject var vm: CountersViewModel = .init()
    @ObservedObject var tabRouter = TabRouterState.shared
    @ObservedObject var router = RouterState.shared
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            if vm.counters.isEmpty {
                EssentialsContentUnavailableView(
                    icon: Image(systemName: "minus.forwardslash.plus"),
                    title: "No Counters Available",
                    description: "You haven't added any counters yet. Tap the '+' button to create a new one.",
                    hasRetryButton: false
                )
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0.0) {
                        ForEach(Array($vm.counters.enumerated()), id: \.0) { index, $counter in
                            Divider()
                            CounterViewListCell(model: $counter) { counterToDelete in
                                vm.deleteCounter(counterToDelete)
                            }
                            if index == vm.counters.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, 16)
        .onAppear {
            tabRouter.currentToolbarRoute = .counters {
                EssentialsHapticService.shared.play(.medium)
                router.currentSheetRoute = .addCounterView(vm)
            }
        }
    }
}

extension CountersView {
    struct Model: Hashable, Codable, Identifiable {
        var id: UUID = .init()
        var count: Int
        let color: Color
        let name: String
    }

    struct CounterViewListCell: View {
        @Binding var model: Model

        let onDelete: (Model) -> Void

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
                }
                .font(.title2)

                Spacer()
                Text(model.name)
                    .font(.title3)
                    .padding(.trailing, 36)
                model.color
                    .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 16.0, bottomLeading: 16.0, bottomTrailing: 0.0, topTrailing: 0.0)))
                    .frame(width: cellHeight)
                    .overlay {
                        Button {
                            EssentialsHapticService.shared.play(.medium)
                            onDelete(model)
                        } label: {
                            Image(systemName: "trash.fill")
                                .foregroundStyle(model.color.isDark() ? Color.tintColor : Color.darkTintColor)
                                .contentShape(Rectangle().size(width: 44, height: 44))
                        }
                    }
            }.frame(height: cellHeight)
                .padding(.leading, 16.0)
        }
    }

    struct AddNewCounterView: View {
        @EnvironmentObject var vm: CountersViewModel
        @FocusState private var isFocused: Bool

        @State var pixelFrameSliderDimensionTextField: String = ""

        var body: some View {
            GeometryReader { geo in
                VStack(spacing: 16.0) {
                    Text("Add New Counter")
                        .font(.largeTitle)
                        .padding(.top, 16.0)
                    HStack {
                        Text("Counter name")
                        Spacer()
                        TextField("Counter name here...", text: $vm.counterName)
                            .focused($isFocused)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: min(geo.size.width * 0.4, 200))
                    }
                    .padding(.horizontal, 16.0)

                    HStack {
                        Text("Initial count")
                        Spacer()
                        TextField("Initial count here...", text: $vm.initialCountTextField)
                            .focused($isFocused)
                            .keyboardType(.numberPad)
                            .padding()
                            .onChange(of: vm.initialCountTextField) { newValue in
                                vm.initialCountTextField = newValue.filter { $0.isNumber }
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: min(geo.size.width * 0.4, 200))
                    }
                    .padding(.horizontal, 16.0)

                    HStack {
                        Text("Color")
                        Spacer()
                        ColorPicker(selection: $vm.counterColor) {
                            EmptyView()
                        }
                        .padding()
                    }
                    .padding(.horizontal, 16.0)
                    .padding(.bottom, 16.0)

                    Button {
                        EssentialsHapticService.shared.play(.medium)
                        vm.createCounter()
                    } label: {
                        Text("Continue")
                    }
                    .disabled(vm.counterName.isEmpty)
                    .animation(.easeInOut(duration: 0.35), value: vm.counterName.isEmpty)
                    .buttonStyle(EssentialsBigButtonStyle())
                    Spacer()
                }
                .padding()
                .modifier(EssentialsAutoHeightSheetModifier(fraction: .constant(0.6)))
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .background(Color.sheetBackgroundColor, ignoresSafeAreaEdges: .all)
                .onAppear {
                    vm.cleanForm()
                }
            }
        }
    }
}

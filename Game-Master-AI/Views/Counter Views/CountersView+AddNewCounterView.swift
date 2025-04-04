//
//  CountersView+AddNewCounterView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 28/02/2025.
//

import Essentials
import SwiftUI

extension CountersView {
    struct AddNewCounterView: View {
        @EnvironmentObject var vm: CountersViewModel
        @FocusState private var isFocused: Bool

        @State var pixelFrameSliderDimensionTextField: String = ""
        @State var sheetHeightFraction: CGFloat = 1.0

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
                .modifier(EssentialsAutoHeightSheetModifier(fraction: $sheetHeightFraction))
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .background(Color.sheetBackgroundColor, ignoresSafeAreaEdges: .all)
                .onAppear {
                    vm.cleanForm()
                }
            }
            .essentialsSheetHeight($sheetHeightFraction, desiredFraction: 0.6)
        }
    }
}

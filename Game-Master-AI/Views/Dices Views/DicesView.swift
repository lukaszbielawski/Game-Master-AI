//
//  DicesView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 12/01/2025.
//

import Essentials
import SceneKit
import SwiftUI

public struct DicesView: View {
    @State private var positionX: CGFloat = .zero
    @State private var positionY: CGFloat = .zero
    @State private var positionZ: CGFloat = .zero

    @State private var rotationX: Angle
    @State private var rotationY: Angle
    @State private var rotationZ: Angle

    @State private var dragGesturePosition: CGSize = .zero

    @State private var isDragging: Bool = false
    @State private var isRolling: Bool = false
    @State private var isRollQueued: Bool = false
    @State private var isDiceChangeQueued: Bool = false

    @State private var diceResult = 20
    @State private var selectedDiceIndex = 4

    let dices: [DiceType] = [.d4, .d6, .d8, .d12, .d20]

    @GestureState private var lastDragGesturePosition: CGSize = .zero

    @EnvironmentObject private var colorSchemeState: EssentialsColorSchemeState

    @EnvironmentObject private var tabRouter: TabRouterState

    var currentDice: DiceType {
        dices[selectedDiceIndex]
    }

    let isOnboardingInitialized: Bool

    public init(isOnboardingInitialized: Bool = false) {
        let defaultOrientation = DiceType.d20.defaultOrientation
        self._rotationX = State(wrappedValue: defaultOrientation.x)
        self._rotationY = State(wrappedValue: defaultOrientation.y)
        self._rotationZ = State(wrappedValue: defaultOrientation.z)
        self.isOnboardingInitialized = isOnboardingInitialized
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geo in
                SceneKitView(size: geo.size,
                             positionX: $positionX,
                             positionY: $positionY,
                             positionZ: $positionZ,
                             rotationX: $rotationX,
                             rotationY: $rotationY,
                             rotationZ: $rotationZ,
                             colorScheme: $colorSchemeState.colorScheme,
                             isDragging: $isDragging,
                             isRolling: $isRolling,
                             isRollQueued: $isRollQueued,
                             isDiceChangeQueued: $isDiceChangeQueued,
                             diceResult: $diceResult,
                             dice: currentDice)
                    .opacity(isRolling ? 0.0 + (isRollQueued ? 0.0 : 1.0) : 1.0)
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isDragging = true
                            let translation = value.translation

                            let deltaWidth = translation.width - lastDragGesturePosition.width
                            let deltaHeight = translation.height - lastDragGesturePosition.height

                            rotationY = Angle(radians: rotationY.radians - Double(deltaHeight) * 0.03)
                            rotationX = Angle(radians: rotationX.radians - Double(deltaWidth) * 0.03)

                            let diagonalMovement = sqrt(deltaWidth * deltaWidth + deltaHeight * deltaHeight)
                            if deltaWidth * deltaHeight > 0 {
                                rotationZ = Angle(radians: rotationZ.radians + Double(diagonalMovement) * 0.005)
                            }
                        }
                        .onEnded { _ in
                            isDragging = false
                            (rotationX, rotationY, rotationZ) = currentDice.getOrientationForResult(result: diceResult)
                        }
                        .updating($lastDragGesturePosition) { value, lastDragGesturePosition, _ in
                            lastDragGesturePosition = value.translation
                        })
            }
            if !isOnboardingInitialized {
                Button(action: {
                    if !isRolling {
                        rollDice()
                        EssentialsHapticService.shared.play(.medium)
                    }
                }, label: {
                    Text("Roll dice")
                        .font(.title)
                        .fontWeight(.thin)
                })
                .opacity(isRolling ? 0.5 : 1)
                .animation(.easeInOut(duration: 0.35), value: isRolling)
                .disabled(isRolling)
                .foregroundStyle(Color.white)
                .padding(.horizontal, 24.0)
                .padding(.vertical, 8.0)
                .background(Capsule(style: .circular).fill(Color.accent))
                .padding(.bottom)

                HStack {
                    Spacer()
                        .frame(maxWidth: .infinity)
                    EssentialsVerticalSegmentedPicker(selection: $selectedDiceIndex, items: dices.map { $0.rawValue })
                        .frame(maxWidth: 80, maxHeight: 175)
                        .padding()
                        .padding(.trailing, 8.0)
                        .opacity(isRolling ? 0.5 : 1)
                        .animation(.easeInOut(duration: 0.35), value: isRolling)
                        .disabled(isRolling)
                        .onChange(of: selectedDiceIndex) { _ in
                            isDiceChangeQueued = true
                            diceResult = 20
                            (rotationX, rotationY, rotationZ) = currentDice.defaultOrientation
                        }
                }
            }
        }
        .onAppear {
            if !isOnboardingInitialized {
                tabRouter.currentToolbarRoute = .diceTab
            }
        }
        .background(Color(.background))
    }

    func rollDice() {
        let generatedRotationXRadians = Double.random(in: (3 * .pi)...(5 * .pi))
        let generatedRotationYRadians = Double.random(in: (3 * .pi)...(5 * .pi))
        let generatedRotationZRadians = Double.random(in: (3 * .pi)...(5 * .pi))

        let generatedPositionX = Double.random(in: -10.0...10.0)
        let generatedPositionY = Double.random(in: -10.0...30.0)
        let generatedPositionZ = Double.random(in: -50.0...(-20.0))

        diceResult = currentDice.rollDice()

        debugPrint("Dice result", diceResult)

        isRolling = true
        isRollQueued = true
        rotationX = Bool.random() ? Angle(radians: generatedRotationXRadians) : Angle(radians: -generatedRotationXRadians)
        rotationY = Bool.random() ? Angle(radians: generatedRotationYRadians) : Angle(radians: -generatedRotationYRadians)
        rotationZ = Bool.random() ? Angle(radians: generatedRotationZRadians) : Angle(radians: -generatedRotationZRadians)

        positionX = generatedPositionX
        positionY = generatedPositionY
        positionZ = generatedPositionZ
    }
}

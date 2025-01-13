//
//  SceneKitView.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 12/01/2025.
//

import SceneKit
import SwiftUI

struct SceneKitView: UIViewRepresentable {
    let size: CGSize

    @Binding var positionX: CGFloat
    @Binding var positionY: CGFloat
    @Binding var positionZ: CGFloat

    @Binding var rotationX: Angle
    @Binding var rotationY: Angle
    @Binding var rotationZ: Angle

    @Binding var colorScheme: ColorScheme
    @Binding var isDragging: Bool
    @Binding var isRolling: Bool
    @Binding var isRollQueued: Bool
    @Binding var isDiceChangeQueued: Bool

    @Binding var diceResult: Int

    var diceResultOrientation: (x: Angle, y: Angle, z: Angle) {
        dice.getOrientationForResult(result: diceResult)
    }

    let dice: DiceType

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: CGRect(origin: .zero, size: size), options: nil)
        view.scene = createScene()
        view.autoenablesDefaultLighting = true
        view.backgroundColor = colorScheme == .dark ? UIColor.black : UIColor.white
        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.backgroundColor = UIColor(Color.background)
        if isDiceChangeQueued {
            isDiceChangeQueued = false
            uiView.scene?.rootNode.childNodes.first?.removeFromParentNode()
            uiView.scene = createScene()
        }

        if let node = uiView.scene?.rootNode.childNodes.first {
            if isRollQueued {
                withAnimation(.easeOut(duration: 0.65)) {
                    isRollQueued = false
                }
                rollDice(node: node,
                         initialPosition: (x: positionX, y: positionY, z: positionZ),
                         initialAngles: (x: rotationX, y: rotationY, z: rotationZ))
                {
                    isRolling = false
                    (rotationX, rotationY, rotationZ) = diceResultOrientation
                }
            }
            if !isRolling {
                if !isDragging {
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 0.35
                }
                node.eulerAngles = SCNVector3(
                    Float(rotationX.radians),
                    Float(rotationY.radians),
                    Float(rotationZ.radians)
                )
                if !isDragging {
                    SCNTransaction.commit()
                }
            }
        }
    }

    private func createScene() -> SCNScene {
        let scene = SCNScene()
        let scale: Float = 1.0

        if let node = dice.createDice(scale: scale, result: 1) {

            node.position = SCNVector3(x: 0, y: 0, z: 0)
            scene.rootNode.addChildNode(node)
        } else {
            debugPrint("Could not load node from file")
        }

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        scene.rootNode.addChildNode(cameraNode)
        return scene
    }

    private func rollDice(node: SCNNode,
                          initialPosition: (x: CGFloat, y: CGFloat, z: CGFloat),
                          initialAngles: (x: Angle, y: Angle, z: Angle),
                          completion: @escaping () -> Void)
    {
        node.eulerAngles = SCNVector3(
            Float(initialAngles.x.radians),
            Float(initialAngles.y.radians),
            Float(initialAngles.z.radians)
        )
        node.position = SCNVector3(
            initialPosition.x,
            initialPosition.y,
            initialPosition.z
        )
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 3.0
        SCNTransaction.animationTimingFunction = .init(controlPoints: 0.14, 1.31, 0.58, 0.98)
        node.eulerAngles = SCNVector3(
            Float(diceResultOrientation.x.radians),
            Float(diceResultOrientation.y.radians),
            Float(diceResultOrientation.z.radians)
        )
        node.position = SCNVector3(0, 0, 0)
        SCNTransaction.completionBlock = completion
        SCNTransaction.commit()
    }
}

//
//  DiceType.swift
//  Game-Master-AI
//
//  Created by Łukasz Bielawski on 12/01/2025.
//

import Foundation
import SceneKit
import SwiftUI

enum DiceType: String {
    case d4, d6, d8, d12, d20

    func createDice(scale: Float = 1.0, result: Int) -> SCNNode? {
        switch self {
        case .d4:
            guard let scene = SCNScene(named: "D4.dae", inDirectory: nil) else {
                return nil
            }
            return scene.rootNode.clone()

        case .d6:
            guard let scene = SCNScene(named: "D6.dae", inDirectory: nil) else {
                return nil
            }
            return scene.rootNode.clone()

        case .d8:
            guard let scene = SCNScene(named: "D8.dae", inDirectory: nil) else {
                return nil
            }
            return scene.rootNode.clone()

        case .d12:
            guard let scene = SCNScene(named: "D12.dae", inDirectory: nil) else {
                return nil
            }
            return scene.rootNode.clone()

        case .d20:
            guard let scene = SCNScene(named: "D20.dae", inDirectory: nil) else {
                return nil
            }
            return scene.rootNode.clone()
        }
    }

    var relativeScale: Float {
        switch self {
        case .d4:
            1.2
        case .d6:
            2.5
        case .d8:
            1.5
        case .d12:
            1.5
        case .d20:
            1.5
        }
    }



    func rollDice() -> Int {
        let range: ClosedRange<Int> = switch self {
        case .d4:
            1...4
        case .d6:
            1...6
        case .d8:
            1...8
        case .d12:
            1...12
        case .d20:
            1...20
        }
        return Int.random(in: range)
    }

    var defaultOrientation: (x: Angle, y: Angle, z: Angle) {
        getOrientationForResult(result: 20)
    }


    func getOrientationForResult(result: Int) -> (x: Angle, y: Angle, z: Angle) {
        let anglesBeforeCorrection: (x: Angle, y: Angle, z: Angle) = switch self {
        case .d4:
            switch result {
            case 1:
                (x: .degrees(90), y: .degrees(-150), z: .degrees(180))
            case 2:
                (x: .degrees(90), y: .degrees(-30), z: .degrees(180))
            case 3:
                (x: .degrees(45), y: .degrees(85), z: .degrees(135))
            default:
                (x: .degrees(0), y: .degrees(-180), z: .degrees(30))
            }
        case .d6:
            switch result {
            case 1:
                (x: .degrees(-90), y: .degrees(-90), z: .degrees(0))
            case 2:
                (x: .degrees(0), y: .degrees(0), z: .degrees(-90))
            case 3:
                (x: .degrees(-90), y: .degrees(0), z: .degrees(0))
            case 4:
                (x: .degrees(-90), y: .degrees(180), z: .degrees(0))
            case 5:
                (x: .degrees(180), y: .degrees(0), z: .degrees(90))
            default:
                (x: .degrees(90), y: .degrees(90), z: .degrees(180))
            }
        case .d8:
            switch result {
            case 1:
                (x: .degrees(-35.264), y: .degrees(-35.264), z: .degrees(-35.264))
            case 2:
                (x: .degrees(-35.264), y: .degrees(35.264), z: .degrees(35.264))
            case 3:
                (x: .degrees(35.264), y: .degrees(35.736), z: .degrees(144.736))
            case 4:
                (x: .degrees(35.264), y: .degrees(-35.736), z: .degrees(-144.736))
            case 5:
                (x: .degrees(-144.736), y: .degrees(35.264), z: .degrees(144.736))
            case 6:
                (x: .degrees(144.736), y: .degrees(35.264), z: .degrees(35.264))
            case 7:
                (x: .degrees(144.736), y: .degrees(-35.264), z: .degrees(-35.264))
            default:
                (x: .degrees(-144.736), y: .degrees(-35.264), z: .degrees(-144.736))
            }
        case .d12:
            switch result {
            case 1:
                (x: .degrees(180), y: .degrees(30), z: .degrees(196.91))
            case 2:
                (x: .degrees(90), y: .degrees(-60), z: .degrees(124))
            case 3:
                (x: .degrees(-180), y: .degrees(-30), z: .degrees(-124))
            case 4:
                (x: .degrees(-60), y: .degrees(0), z: .degrees(144))
            case 5:
                (x: .degrees(-120), y: .degrees(0), z: .degrees(-36))
            case 6:
                (x: .degrees(-90), y: .degrees(-60), z: .degrees(196.91))
            case 7:
                (x: .degrees(90), y: .degrees(60), z: .degrees(163.09))
            case 8:
                (x: .degrees(-300), y: .degrees(0), z: .degrees(180))
            case 9:
                (x: .degrees(-240), y: .degrees(0), z: .degrees(-144))
            case 10:
                (x: .degrees(0), y: .degrees(30), z: .degrees(126))
            case 11:
                (x: .degrees(-90), y: .degrees(60), z: .degrees(-124))
            default:
                (x: .degrees(0), y: .degrees(-30), z: .degrees(163.09))
            }
        case .d20:
            switch result {
            case 1:
                (x: .degrees(-2), y: .degrees(77), z: .degrees(-92)) //
            case 2:
                (x: .degrees(-67), y: .degrees(-56), z: .degrees(-78)) //
            case 3:
                (x: .degrees(150), y: .degrees(30), z: .degrees(45)) //
            case 4:
                (x: .degrees(30), y: .degrees(-30), z: .degrees(-135)) //
            case 5:
                (x: .degrees(-38.5), y: .degrees(9.5), z: .degrees(14)) //
            case 6:
                (x: .degrees(100), y: .degrees(-15), z: .degrees(-64)) //
            case 7:
                (x: .degrees(250), y: .degrees(54), z: .degrees(105)) //
            case 8:
                (x: .degrees(-180), y: .degrees(-37), z: .degrees(-90)) //
            case 9:
                (x: .degrees(75), y: .degrees(15), z: .degrees(115)) //
            case 10:
                (x: .degrees(-145), y: .degrees(-10), z: .degrees(-45)) //
            case 11:
                (x: .degrees(37), y: .degrees(10), z: .degrees(46)) //
            case 12:
                (x: .degrees(-105), y: .degrees(-18), z: .degrees(-115)) //
            case 13:
                (x: .degrees(3), y: .degrees(39.5), z: .degrees(92)) //
            case 14:
                (x: .degrees(70), y: .degrees(-57), z: .degrees(-105)) //
            case 15:
                (x: .degrees(280), y: .degrees(15), z: .degrees(64)) //
            case 16:
                (x: .degrees(144), y: .degrees(-13.4), z: .degrees(-134)) //
            case 17:
                (x: .degrees(30), y: .degrees(150), z: .degrees(-45)) //
            case 18:
                (x: .degrees(157), y: .degrees(-154), z: .degrees(-227)) //
            case 19:
                (x: .degrees(-77.6), y: .degrees(125), z: .degrees(-110))
            default:
                (x: .degrees(-176), y: .degrees(277), z: .degrees(85))
            }
        }
        return (x: Angle(degrees: anglesBeforeCorrection.x.degrees),
                y: Angle(degrees: anglesBeforeCorrection.y.degrees),
                z: Angle(degrees: anglesBeforeCorrection.z.degrees))
    }
}

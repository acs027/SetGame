//
//  Extension+UIColor.swift
//  SetGame
//
//  Created by ali cihan on 15.10.2024.
//

import Foundation
import SwiftUI


extension Color {
    static func cardColor(_ color: SetGame.cardColor) -> Color {
        switch color {
        case .red:
            return Color.red
        case .blue:
            return Color.blue
        case .green:
            return Color.green
        }
    }
}

//
//  Extension+Shape.swift
//  SetGame
//
//  Created by ali cihan on 18.10.2024.
//

import SwiftUI

extension Shape {
    func shading(_ shading: SetGame.cardShading) -> some View {
        switch shading {
        case .open:
            return AnyView(self.stroke(lineWidth: 3))
        case .striped:
            return AnyView(
                self
                    .stroke(lineWidth: 3)
                    .overlay {
                        Stripes()
                            .stroke(lineWidth: 1)
                    }
                    .mask(self))
        case .solid:
            return AnyView(self.fill())
        }
    }
}

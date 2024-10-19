//
//  Cardify.swift
//  SetGame
//
//  Created by ali cihan on 19.10.2024.
//

import SwiftUI


struct Cardify: ViewModifier {
    let isSelected: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .strokeBorder(lineWidth: Constants.lineWidth)
                .overlay(content)
        }
    }
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
}

extension View {
    func cardify(isSelected: Bool) -> some View {
        modifier(Cardify(isSelected: isSelected))
    }
}


//
//  Cardify.swift
//  SetGame
//
//  Created by ali cihan on 19.10.2024.
//

import SwiftUI


struct Cardify: ViewModifier, Animatable {
    init(isFaceUp: Bool, isSelected: Bool) {
        rotation = isFaceUp ? 0 : 180
        self.isSelected = isSelected
    }
    
    var isSelected: Bool
    
    var isFaceUp: Bool {
        rotation < 90
    }
    var rotation: Double
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
                base.fill(Color.white)
                .strokeBorder(lineWidth: isSelected ? Constants.selectedLineWitdh : Constants.lineWidth)
                .foregroundStyle(isSelected ? .purple : .black)
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            base.fill(Color.purple)
                .strokeBorder(lineWidth: Constants.lineWidth)
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(.degrees(rotation), axis: (0,1,0))
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
        static let selectedLineWitdh: CGFloat = 5
    }
}

extension View {
    func cardify(isFaceUp: Bool, isSelected: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, isSelected: isSelected))
    }
}


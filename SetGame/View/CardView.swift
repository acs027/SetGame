//
//  CardView.swift
//  SetGame
//
//  Created by ali cihan on 18.10.2024.
//

import SwiftUI

struct CardView: View {
    let card: SetGame.Card
    
    init(_ card: SetGame.Card) {
        self.card = card
    }
    
    var body: some View {
        Pie(endAngle: .degrees(240))
            .opacity(0.5)
            .overlay {
                VStack(spacing: 10) {
                    ForEach((1...card.number), id: \.self) { _ in
                        cardComponent
                            .foregroundStyle(Color.cardColor(card.color))
                            .aspectRatio(2, contentMode: .fit)
                    }
                }
            }
            .padding()
            .cardify(isSelected: card.isSelected)
    }
    
    @ViewBuilder
    var cardComponent: some View {
        switch card.shape {
        case .diamond:
            Diamond()
                .shading(card.shading)
        case .oval:
            Capsule()
                .shading(card.shading)
        case .rectangle:
            Rectangle()
                .shading(card.shading)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        typealias Card = SetGame.Card
        var body: some View {
            HStack {
                CardView(Card(shape: .oval, shading: .solid, color: .green, number: 1))
                    .aspectRatio(2/3, contentMode: .fit)
                CardView(Card(shape: .diamond, shading: .open, color: .blue, number: 2))
                    .aspectRatio(2/3, contentMode: .fit)
                CardView(Card(shape: .rectangle, shading: .striped, color: .red, number: 3))
                    .aspectRatio(2/3, contentMode: .fit)
            }
            .padding()
        }
    }
    return PreviewWrapper()
}

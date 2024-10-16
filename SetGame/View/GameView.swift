//
//  GameView.swift
//  SetGame
//
//  Created by ali cihan on 14.10.2024.
//

import SwiftUI


struct GameView: View {
    @ObservedObject private var viewModel: GameViewModel = GameViewModel()
    let aspectRatio: CGFloat = 2/3
    var body: some View {
        VStack {
            HStack {
                Text("Score: \(viewModel.score)")
                Spacer()
                Button("New Game") { viewModel.newGame() }
            }
            cards
                .animation(.default, value: viewModel.cardsInPlay)
            Button("Add 3 cards") {
                viewModel.addCardFromDeck(count: 3)
            }
            .opacity(viewModel.isAddCardButtonDisabled() ? 0: 1)
        }
        .padding()
    }
    
    var cards: some View {
        AspectVGrid(viewModel.cardsInPlay, aspectRatio: aspectRatio) { card in
            CardView(card)
                .padding(5)
                .onTapGesture {
                    viewModel.cardSelectAndCheckSet(card)
                }
        }
    }
}

struct CardView: View {
    let card: SetGame.Card
    
    init(_ card: SetGame.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            base.stroke(card.isSelected ? Color.orange : Color.black, lineWidth: 3)
            VStack(spacing: 10) {
                ForEach((1...card.number), id: \.self) { _ in
                    CardShape(card: card)
                }
            }
            .zIndex(99)
            .padding()
        }
    }
}

struct CardShape: View {
    let card: SetGame.Card
    var body: some View {
        Group {
            switch card.shape {
            case .diamond:
                Diamond()
                    .if(card.shading != .solid) { view in
                        view.stroke(lineWidth: 3)
                    }
                    .aspectRatio(2, contentMode: .fit)
            case .oval:
                Capsule()
                    .if(card.shading != .solid) { view in
                        view.stroke(lineWidth: 3)
                    }
                    .aspectRatio(2, contentMode: .fit)
            case .rectangle:
                Rectangle()
                    .if(card.shading != .solid) { view in
                        view.stroke(lineWidth: 3)
                    }
                    .aspectRatio(2, contentMode: .fit)
            }
        }
        .overlay {
            card.shading == .striped ? Stripes().stroke(lineWidth: 1) : nil
        }
        .if(card.shape == .diamond, transform: { view in
            view.mask {
                Diamond()
            }
        })
        .if(card.shape == .oval, transform: { view in
            view.mask {
                Capsule()
            }
        })
        .foregroundStyle(Color.cardColor(card.color))
    }
}

struct Stripes: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        for x in stride(from: 0, through: width, by: width / 9) {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: height))
        }
        return path
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

#Preview {
    GameView()
}

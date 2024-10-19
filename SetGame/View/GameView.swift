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

#Preview {
    GameView()
}

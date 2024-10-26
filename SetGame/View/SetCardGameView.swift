//
//  GameView.swift
//  SetGame
//
//  Created by ali cihan on 14.10.2024.
//

import SwiftUI


struct GameView: View {
    @ObservedObject private var viewModel: GameViewModel = GameViewModel()
    private let aspectRatio: CGFloat = 2/3
    private let deckWidth: CGFloat = 90
    
    var body: some View {
        VStack {
            HStack {
                Text("Score: \(viewModel.score)")
                Spacer()
                newGame
            }
            cards
            HStack(spacing: deckWidth/aspectRatio - deckWidth) {
                deck
                shuffleDeck
                discardPile
            }
        }
        .padding()
    }
    
    private var shuffleDeck: some View {
        Button("Shuffle") {
            viewModel.shuffleDeck()
        }
    }
    
    private var newGame: some View {
        Button("New Game") {
            withAnimation(.easeIn(duration: 1)) {
                viewModel.newGame()
            }
        }
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cardsInPlay, aspectRatio: aspectRatio) { card in
            CardView(card)
                .matchedGeometryEffect(id: card.id, in: discardedNamespace)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .transition(.asymmetric(insertion: .identity, removal: .identity))
                .padding(5)
                .onTapGesture {
                    withAnimation {
                        viewModel.cardSelectAndCheckSet(card)
                    }
                    
                }
                .onAppear {
                    withAnimation {
                        viewModel.faceUpCard(card)
                    }

                }
        }
    }
    
    @Namespace private var dealingNamespace
    
    private var deck: some View {
        ZStack {
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: discardedNamespace)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .rotationEffect(.degrees(viewModel.shuffleRotationDegree))
                    .animation(.easeInOut.delay(shuffleAnimationDelay(card.id)), value: viewModel.shuffleRotationDegree)
                    .onAppear {
                        withAnimation {
                            viewModel.faceDownCard(card)
                        }
                    }
            }
        }
//        .rotationEffect(.degrees(viewModel.shuffleRotationDegree))
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            withAnimation {
                viewModel.addCardFromDeck()
            }
            
        }
        .disabled(viewModel.isAddCardDisabled())
    }
    
    @Namespace private var discardedNamespace
    
    private var discardPile: some View {
        ZStack {
            ForEach(viewModel.discardPile) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: discardedNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .zIndex(index(card))
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
    }
    
    func shuffleAnimationDelay(_ cardID: UUID) -> Double {
        guard let index = viewModel.cards.firstIndex(where: {$0.id == cardID}) else { return 0 }
        let delay = Double(index) * 0.02
        return max(delay, 0.2)
    }
    
    func index(_ card: SetGame.Card) -> Double {
        guard let index = viewModel.discardPile.firstIndex(of: card) else { return 0 }
        return Double(index)
    }
}

#Preview {
    GameView()
}

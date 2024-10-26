//
//  ViewModel.swift
//  SetGame
//
//  Created by ali cihan on 14.10.2024.
//

import Foundation


class GameViewModel: ObservableObject {
    private static func createSetGame() -> SetGame {
        var game = SetGame()
        game.createDeck()
        return game
    }
    
    @Published private var model = createSetGame()
    
    var cards: [SetGame.Card] {
        model.cards
    }
    
    var cardsInPlay: [SetGame.Card] {
        model.cardsInPlay
    }
    
    var discardPile: [SetGame.Card] {
        model.discardPile
    }
    
    var score: Int {
        model.score
    }
    
    var shuffleRotationDegree: Double = 0 {
        didSet {
            shuffleRotationDegree = oldValue + 180
        }
    }
    
    func shuffleDeck() {
        model.shuffleDeck()
        shuffleRotationDegree = 1
    }
    
    func addCardFromDeck() {
        var count = 3
        if cardsInPlay.isEmpty {
            count = 12
        }
        for _ in 0..<count {
            model.addCardFromDeck()
        }
    }
    
    func isAddCardDisabled() -> Bool {
        cardsInPlay.count > 12
    }
    
    func cardSelectAndCheckSet(_ card: SetGame.Card) {
        model.cardSelectAndCheckSet(card)
    }
    
    func faceDownCard(_ card: SetGame.Card) {
        model.faceDownCard(card)
    }
    
    func faceUpCard(_ card: SetGame.Card) {
        model.faceUpCard(card)
    }
    
    func newGame() {
        model.newGame()
    }
}

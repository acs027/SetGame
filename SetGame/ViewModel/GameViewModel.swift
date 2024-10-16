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
        game.addCardFromDeck(count: 12)
        return game
    }
    
    @Published private var model = createSetGame()
    
    var cardsInPlay: [SetGame.Card] {
        model.cardsInPlay
    }
    
    var score: Int {
        model.score
    }
    
    func addCardFromDeck(count: Int) {
        model.addCardFromDeck(count: count)
    }
    
    func isAddCardButtonDisabled() -> Bool {
        model.cardsInPlay.count > 12
    }
    
    func cardSelectAndCheckSet(_ card: SetGame.Card) {
        model.cardSelectAndCheckSet(card)
    }
    
    func newGame() {
        model.newGame()
    }
}

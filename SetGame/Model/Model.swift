//
//  Model.swift
//  SetGame
//
//  Created by ali cihan on 14.10.2024.
//

import Foundation


struct SetGame {
    private(set) var cards: [Card]
    private(set) var cardsInPlay: [Card]
    private(set) var selectedCardsCount = 0
    private(set) var score = 0 {
        willSet {
            if cardsInPlay.count < 12 {
                addCardFromDeck(count: 12 - cardsInPlay.count)
            }
        }
    }
    
    init() {
        cards = []
        cardsInPlay = []
    }
    
    mutating func createDeck() {
        for shape in cardShape.allCases {
            for color in cardColor.allCases {
                for shading in cardShading.allCases {
                    for number in Range(1...3) {
                        cards.append(Card(shape: shape, shading: shading, color: color, number: number))
                    }
                }
            }
        }
    }
    
    mutating func newGame() {
        cards.removeAll()
        cardsInPlay.removeAll()
        createDeck()
        score = 0
    }
    
    
    enum cardShape: CaseIterable {
        case diamond, oval, rectangle
    }

    enum cardShading: CaseIterable {
        case solid, striped, open
    }

    enum cardColor: CaseIterable {
        case red, green, blue
    }
    
    mutating func addCardFromDeck(count: Int) {
        if cards.count > 0 {
            for _ in 0..<count {
                let randomIndex = Int.random(in: 0..<cards.count)
                cardsInPlay.append(cards.remove(at: randomIndex))
            }
        }
    }
    
    mutating func cardSelectAndCheckSet(_ card: Card) {
        if selectedCardsCount < 3 {
            guard let index = cardsInPlay.firstIndex(where: {
                $0.id == card.id
            }) else { return }
            selectedCardsCount += card.isSelected ? -1 : 1
            cardsInPlay[index].isSelected.toggle()
        }
        if selectedCardsCount > 2 {
            checkSet(lastSelectedCardId: card.id)
        }
    }
    
    mutating func checkSet(lastSelectedCardId: UUID = UUID()) {
        if isSet() {
            cardsInPlay = cardsInPlay.filter({
                !$0.isSelected
            })
            score += 1
            selectedCardsCount = 0
        } else {
            score -= 1
            selectedCardsCount = 1
        }
        cardsInPlay.indices.forEach {
            cardsInPlay[$0].isSelected = cardsInPlay[$0].id != lastSelectedCardId ? false : true
        }
    }
    
    func isSet() -> Bool {
        let selectedCards = cardsInPlay.filter(\.isSelected)
        
        let isSameShading = Set(selectedCards.map {$0.shading}).count == 1
        let isDifferentShading = Set(selectedCards.map {$0.shading }).count == 3
        
        if !(isSameShading || isDifferentShading) { return false }
        
        let isSameColor = Set(selectedCards.map {$0.color}).count == 1
        let isDifferentColor = Set(selectedCards.map {$0.color }).count == 3
        
        if !(isSameColor || isDifferentColor) { return false}
        
        let isSameShape = Set(selectedCards.map {$0.shape}).count == 1
        let isDifferentShape = Set(selectedCards.map {$0.shape }).count == 3
        
        if !(isSameShape || isDifferentShape) { return false }
        
        let isSameNumber = Set(selectedCards.map {$0.number}).count == 1
        let isDifferentNumber = Set(selectedCards.map {$0.number }).count == 3
        
        if !(isSameNumber || isDifferentNumber) { return false }
        return true
    }
    
    
    struct Card: Identifiable, Equatable {
        var shape: cardShape
        var shading: cardShading
        var color: cardColor
        var number: Int
        var isSelected = false
        
        var id = UUID()
    }
}


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
    private(set) var discardPile: [Card]
    private(set) var selectedCardsCount = 0
    private(set) var score = 0
    
    init() {
        cards = []
        cardsInPlay = []
        discardPile = []
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
        cards.shuffle()
    }
    
    mutating func newGame() {
        while !cardsInPlay.isEmpty {
            var card = cardsInPlay.removeFirst()
            card.isSelected = false
            cards.append(card)
        }
        while !discardPile.isEmpty {
            var card = discardPile.removeFirst()
            card.isSelected = false
            cards.append(card)
        }
        
        cards.shuffle()
        score = 0
        selectedCardsCount = 0
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
    
    mutating func addCardFromDeck() {
        if cards.count > 0 {
            cardsInPlay.append(cards.removeFirst())
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
            for _ in 0..<3 {
                if cardsInPlay.count > 12 || cards.isEmpty {
                    sendToDiscard()
                } else {
                    sendToDiscardAndGetNewCard()
                }
            }
            score += 1
        } else {
            score -= 1
            selectedCardsCount = 1
            cardsInPlay.indices.forEach {
                cardsInPlay[$0].isSelected = cardsInPlay[$0].id != lastSelectedCardId ? false : true
            }
        }
    }
    
    mutating func sendToDiscard() {
        guard let index = cardsInPlay.firstIndex(where: {
            $0.isSelected
        }) else { return }
        var card = cardsInPlay.remove(at: index)
        card.isSelected = false
        discardPile.append(card)
        selectedCardsCount -= 1
    }
    
    mutating func sendToDiscardAndGetNewCard() {
        guard let index = cardsInPlay.firstIndex(where: {
            $0.isSelected
        }) else { return }
        var discardedCard = cardsInPlay.remove(at: index)
        discardedCard.isSelected = false
        discardPile.append(discardedCard)
        cardsInPlay.insert(cards.removeFirst(), at: index)
        selectedCardsCount -= 1
    }
    
    func isSet() -> Bool {
        
        return true // MARK: For Testing. Should be removed after testing.
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
    
    mutating func faceUpCard(_ card: Card) {
        guard let index = cardsInPlay.firstIndex(of: card) else { return }
        cardsInPlay[index].isFaceUp = true
    }
    
    mutating func faceDownCard(_ card: Card) {
        guard let index = cards.firstIndex(of: card) else { return }
        cards[index].isFaceUp = false
        cards[index].isSelected = false
    }
    
    mutating func shuffleDeck() {
        cards.shuffle()
    }
    
    
    struct Card: Identifiable, Equatable {
        var shape: cardShape
        var shading: cardShading
        var color: cardColor
        var number: Int
        var isSelected = false {
            willSet {
                if newValue {
                    startTime()
                } else {
                    stopTime()
                }
            }
        }
        var isFaceUp = false
        
        var id = UUID()
        
        
        private mutating func startTime() {
            selectTime = Date()
        }
        
        private mutating func stopTime() {
            selectTime = nil
        }
        
        var selectTime: Date?
        
        var timeLimit: TimeInterval = 10
        
        var timeLeft: Double {
            if let selectTime {
                let pastTime = (timeLimit - Date().timeIntervalSince(selectTime))/timeLimit
                return max(0, pastTime)
            } else {
                return 1
            }
        }
    }
}


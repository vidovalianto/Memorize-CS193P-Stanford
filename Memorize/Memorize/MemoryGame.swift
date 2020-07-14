//
//  MemoryGame.swift
//  Memorize
//
//  Created by Vido Valianto on 5/28/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>

    private var indexOfFaceUpCard: Int? {
        get { cards.indices.filter { self.cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }

    public init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: pairIndex*2, isFaceUp: false, isMatched: false, content: content))
            cards.append(Card(id: pairIndex*2+1, isFaceUp: false, isMatched: false, content: content))
        }
        cards.shuffle()
    }

    mutating func choose(card: Card) {
        let chosenCard = self.cards[self.index(of: card)]
        if !chosenCard.isFaceUp, !chosenCard.isMatched {
            if let potentialMatch = indexOfFaceUpCard {
                if self.cards[potentialMatch].content == chosenCard.content {
                    self.cards[potentialMatch].isMatched = true
                    self.cards[self.index(of: card)].isMatched = true
                }
                self.cards[self.index(of: card)].isFaceUp = true
            } else {
                indexOfFaceUpCard = self.index(of: card)
            }
        }
    }

    private func index(of card: Card) -> Int {
        return self.cards.firstIndex { $0.id == card.id } ?? -1
    }

    struct Card: Identifiable {
        var id: Int
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent

        var bonusTimeLimit: TimeInterval = 6

        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpdate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        var lastFaceUpdate: Date?
        var pastFaceUpTime: TimeInterval = 0

        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }

        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }

        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }

        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpdate == nil {
                lastFaceUpdate = Date()
            }
        }

        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpdate = nil
        }
    }
}

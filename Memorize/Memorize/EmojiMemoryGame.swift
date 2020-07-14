//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Vido Valianto on 5/28/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published
    private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()

    private static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["🤔", "🌚", "🍙"]
        return MemoryGame<String>(numberOfPairsOfCards: 3) {
            pairIndex in
            return emojis[pairIndex]
        }
    }

    // MARK: - Access to the Model

    public var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }

    //MARK: - Intent(s)

    public func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }

    public func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}

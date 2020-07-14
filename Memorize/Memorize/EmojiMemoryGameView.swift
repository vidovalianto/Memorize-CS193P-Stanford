//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Vido Valianto on 5/22/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    var body: some View {
        VStack {
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.75)) {
                        self.viewModel.choose(card: card)
                    }
                }.padding()
            }
            .foregroundColor(.orange)
            .padding()

            Button(action: {
                withAnimation(.easeInOut) {
                    self.viewModel.resetGame()
                }
            }, label: { Text ("New Game")})
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card

    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }

    @State private var animatedBonusRemaining: Double = 0

    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }

    @ViewBuilder
    func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90),
                        endAngle: Angle.degrees(-animatedBonusRemaining*360-90),
                        clockwise: true)
                            .onAppear {
                                self.startBonusTimeAnimation()
                        }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90),
                            endAngle: Angle.degrees(-card.bonusRemaining*360-90),
                        clockwise: true)
                    }
                }
                .padding(5)
                .opacity(0.4)
                .transition(.scale)

                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1)
                        .repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(.scale)
            
        }

        return Emp
    }

    // MARK: - Drawing Constants
    let cornerRadius: CGFloat = 10.0

    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}

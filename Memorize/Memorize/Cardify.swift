//
//  View+Cardify.swift
//  Memorize
//
//  Created by Vido Valianto on 6/8/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
    public var isFaceUp: Bool {
        rotation < 90
    }
    public var rotation: Double
    public var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }

    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }

    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke()
                content
            }
            .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .fill()
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(.degrees(rotation), axis: (0,1,0))
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}

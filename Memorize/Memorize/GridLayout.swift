//
//  GridLayout.swift
//  Memorize
//
//  Created by Vido Valianto on 5/28/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import SwiftUI

struct GridLayout {
    private(set) var size: CGSize
    private(set) var rowCount: Int = 0
    private(set) var columnCount: Int = 0

    public init(itemCount: Int, nearAspectRatio desiredAspectRation: Double = 1, in size: CGSize) {
        self.size = size
        let area = size.width * size.height
        let itemArea: Double = Double (area / CGFloat(itemCount))
        self.columnCount = Int(Double(size.width) / itemArea.squareRoot())
        if columnCount == 1 { self.columnCount = 2 }
        self.rowCount = Int(Double(size.height) / itemArea.squareRoot())
        if rowCount == 1 { self.rowCount = 2 }
    }

    public var itemSize: CGSize {
        let width = self.size.width / CGFloat(self.columnCount)
        let height = self.size.height / CGFloat(self.rowCount)
        return CGSize(width: width, height: height)
    }

    public func location(ofItemAt index: Int) -> CGPoint {
//        let midPoint = itemSize.width/2
        let startX: Int = (index % columnCount)
        let startY: Int = index / columnCount
        let x = (CGFloat(startX) * itemSize.width) + (itemSize.width/2)
        let y = (CGFloat(startY) * itemSize.height) + (itemSize.height/2)
        return CGPoint(x: x, y: y)
    }
}


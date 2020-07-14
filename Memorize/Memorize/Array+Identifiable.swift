//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Vido Valianto on 6/8/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    public func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id { return index }
        }

        return nil
    }
}

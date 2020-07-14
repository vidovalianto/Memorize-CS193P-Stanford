//
//  Array+Only.swift
//  Memorize
//
//  Created by Vido Valianto on 6/8/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}

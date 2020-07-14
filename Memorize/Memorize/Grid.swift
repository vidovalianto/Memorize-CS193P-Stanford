//
//  Grid.swift
//  Memorize
//
//  Created by Vido Valianto on 5/28/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import SwiftUI

extension Grid where Item: Identifiable, ID == Item.ID {
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.init(items: items, id: \Item.id, viewForItem: viewForItem)
    }
}

struct Grid<Item, ID, ItemView>: View where ID: Hashable, ItemView: View {
    private var items: [Item]
    private var id: KeyPath<Item,ID>
    private var viewForItem: (Item) -> ItemView

    init(items: [Item], id:KeyPath<Item,ID>, viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForItem = viewForItem
    }

    var body: some View {
        GeometryReader { geometry in
            self.body(for: GridLayout(itemCount: self.items.count,
                                      in: geometry.size))
        }
    }

    func body(for layout: GridLayout) -> some View {
        return ForEach(items, id: self.id) { item in
            self.body(for: item, in: layout)
        }
    }

    func body(for item: Item, in layout: GridLayout) -> some View {
        let index = self.index(of: item)
        return viewForItem(item)
            .frame(width: layout.itemSize.width,
                   height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
    }

    func index(of item: Item) -> Int {
        return items.firstIndex(where: { $0[keyPath: id] == item[keyPath: id] }) ?? -1
    }
}

//
//  NestedList.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.24.
//

import SwiftUI

protocol NestedListItem {
    associatedtype Item: Identifiable

    var children: [Item]? { get }
}

struct NestedList<RowItem, Content>: View where RowItem: Identifiable, Content: View {
    // MARK: Nested Types

    struct Item: NestedListItem, Identifiable {
        // MARK: Properties

        let item: RowItem
        let _children: (RowItem) -> [RowItem]?

        // MARK: Computed Properties

        var id: RowItem.ID { item.id }

        var children: [Item]? {
            guard let children = _children(item) else { return nil }
            return children.map { Item(item: $0, children: _children) }
//            guard !filter.subFilters.isEmpty else { return nil }
//            return filter.subFilters.sorted(by: { $0.description < $1.description }).map { Item(filter: $0) }
        }
        
        init(item: RowItem, children: @escaping (RowItem) -> [RowItem]?) {
            self.item = item
            self._children = children
        }
    }

//
//    @Environment(\.document) var document
//    @State var selection: Structure.Filter.ID?
//
//
//    var filters: [Item] {
//        document.structure.filters.filter { $0.superFilters.isEmpty }.sorted(by: { $0.description < $1.description }).map { Item(filter: $0) }
//    }

    // MARK: Properties

    @State var data: [RowItem]
    @Binding var selection: RowItem.ID?
    @State var content: (RowItem) -> Content
    @State var children: (RowItem) -> [RowItem]?

    // MARK: Content
    
    var items: [Item] {
        data.map { Item(item: $0, children: children) }
    }

    var body: some View {
        List(items, id: \.id, children: \.children, selection: $selection) { item in
            content(item.item)
        }
    }
}

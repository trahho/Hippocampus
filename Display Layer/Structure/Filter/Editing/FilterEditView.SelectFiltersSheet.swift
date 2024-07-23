//
//  FilterEditView.SelectFiltersSheet.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.07.24.
//

import SwiftUI

struct SelectFiltersSheet: View {
    // MARK: Nested Types

    struct Entry: Identifiable, Hashable {
        // MARK: Properties

        let item: Structure.Filter
        let filter: Structure.Filter

        // MARK: Computed Properties

        var id: Structure.Filter.ID { filter.id }
        var text: String { filter.name.localized(filter.isLocked) }

        var children: [Entry]? {
            let result = filter.subFilters
//                    .filter { !$0.conforms(to: item) }
                .sorted(by: { $0.name.localized($0.isLocked) < $1.name.localized($1.isLocked) })
                .map { Entry(item: item, filter: $0) }
            return result.isEmpty ? nil : result
        }
    }

    // MARK: Properties

    @Environment(\.document) var document
    @Binding var filter: Structure.Filter

    // MARK: Computed Properties

    var roots: [Entry] {
        document.structure.filters
            .filter { $0.superFilters.isEmpty && $0 != filter }
            .sorted(by: { $0.name.localized($0.isLocked) < $1.name.localized($1.isLocked) })
            .map { Entry(item: filter, filter: $0) }
    }

    // MARK: Content

    var body: some View {
        List(roots, children: \.children) { entry in
            HStack {
                if filter == entry.filter {
                    Image(systemName: "circle.circle")
                } else if filter.subFilters.contains(entry.filter) {
                    Image(systemName: "xmark.circle")
                } else if filter.superFilters.contains(entry.filter) {
                    Image(systemName: "checkmark.circle")
                } else {
                    Image(systemName: "circle")
                }
                Text(entry.text)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                guard filter != entry.filter, !filter.subFilters.contains(entry.filter) else { return }
                if filter.superFilters.contains(entry.filter) {
                    filter.superFilters.removeAll(where: { $0 == entry.filter })
                } else {
                    filter.superFilters.append(entry.filter)
                }
            }
        }
    }
}

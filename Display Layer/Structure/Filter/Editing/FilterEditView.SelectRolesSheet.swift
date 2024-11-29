//
//  FilterEditView.SelectPerspectivesSheet.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.07.24.
//

import SwiftUI

extension FilterEditView {
    struct SelectPerspectivesSheet: View {
        // MARK: Nested Types

        struct Entry: Identifiable, Hashable {
            // MARK: Properties

//            let item: Structure.Perspective
            let perspective: Structure.Perspective

            // MARK: Computed Properties

            var id: Structure.Perspective.ID { perspective.id }
            var text: String { perspective.name.localized(perspective.isStatic) }

            var children: [Entry]? {
                let result = perspective.subPerspectives
                    .sorted(by: { $0.name.localized($0.isStatic) < $1.name.localized($1.isStatic) })
                    .map { Entry(perspective: $0) }
                return result.isEmpty ? nil : result
            }
        }

        // MARK: Properties

        @Environment(\.document) var document
        @Binding var filter: Structure.Filter

        // MARK: Computed Properties

        var roots: [Entry] {
            document.structure.perspectives
                .filter { $0 != Structure.Perspective.Statics.same }
                .sorted(by: { $0.name.localized($0.isStatic) < $1.name.localized($1.isStatic) })
                .map { Entry(perspective: $0) }
        }

        // MARK: Content

        var body: some View {
            List(roots, children: \.children) { entry in
                HStack {
                    if filter.perspectives.contains(entry.perspective) {
                        Image(systemName: "checkmark.circle")
                    } else {
                        Image(systemName: "circle")
                    }
                    Text(entry.text)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if filter.perspectives.contains(entry.perspective) {
                        filter.perspectives.removeAll(where: { $0 == entry.perspective })
                    } else {
                        filter.perspectives.append(entry.perspective)
                    }
                }
            }
        }
    }
}

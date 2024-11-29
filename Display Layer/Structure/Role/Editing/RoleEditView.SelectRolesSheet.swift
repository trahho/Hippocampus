//
//  PerspectiveEditView+SelectPerspectivesSheet.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.06.24.
//

import Foundation
import Grisu
import Smaug
import SwiftUI

extension PerspectiveEditView {
    struct SelectPerspectivesSheet: View {
        // MARK: Nested Types

        struct Entry: Identifiable, Hashable {
            // MARK: Properties

            let item: Structure.Perspective
            let perspective: Structure.Perspective

            // MARK: Computed Properties

            var id: Structure.Perspective.ID { perspective.id }
            var text: String { perspective.description }

            var children: [Entry]? {
                let result = perspective.subPerspectives
                    .filter { !$0.conforms(to: item) }
                    .sorted(by: { $0.description < $1.description })
                    .map { Entry(item: item, perspective: $0) }
                return result.isEmpty ? nil : result
            }
        }

        // MARK: Properties

        @Environment(\.document) var document
        @Binding var perspective: Structure.Perspective

        // MARK: Computed Properties

        var roots: [Entry] {
            document.structure.perspectives
                .filter { $0.perspectives.isEmpty && $0 != Structure.Perspective.Statics.same && $0 != perspective }
                .sorted(by: { $0.description < $1.description })
                .map { Entry(item: perspective, perspective: $0) }
        }

        // MARK: Content

        var body: some View {
            List(roots, children: \.children) { entry in
                HStack {
                    if perspective == entry.perspective {
                        Image(systemName: "circle.circle")
                    } else if perspective.subPerspectives.contains(entry.perspective) {
                        Image(systemName: "xmark.circle")
                    } else if perspective.perspectives.contains(entry.perspective) {
                        Image(systemName: "checkmark.circle")
                    } else {
                        Image(systemName: "circle")
                    }
                    Text(entry.text)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    guard perspective != entry.perspective, !perspective.subPerspectives.contains(entry.perspective) else { return }
                    if perspective.perspectives.contains(entry.perspective) {
                        perspective.perspectives.removeAll(where: { $0 == entry.perspective })
                    } else {
                        perspective.perspectives.append(entry.perspective)
                    }
                }
            }
        }
    }
}

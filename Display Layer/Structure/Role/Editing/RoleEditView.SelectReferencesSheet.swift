//
//  PerspectiveEditView+SelectReferencesSheet.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.06.24.
//

import Foundation
import SwiftUI

extension PerspectiveEditView {
    struct SelectReferencesSheet: View {
        @Environment(\.document) var document
        @Binding var perspective: Structure.Perspective
        
        struct Entry: Identifiable, Hashable {
            let item: Structure.Perspective
            let perspective: Structure.Perspective
            var id: Structure.Perspective.ID { perspective.id }
            var text: String { perspective.description }
            var children: [Entry]? {
                let result = perspective.perspectives
                    .filter { $0 != item }
                    .sorted(by: { $0.description < $1.description })
                    .map { Entry(item: item, perspective: $0) }
                return result.isEmpty ? nil : result
            }
        }
        
        var roots: [Entry] {
            document.structure.perspectives
                .filter { $0.subPerspectives.isEmpty && $0 != perspective }
                .sorted(by: { $0.description < $1.description })
                .map { Entry(item: perspective, perspective: $0) }
        }
        
        var body: some View {
            List(roots, children: \.children) { entry in
                HStack {
                    if perspective == entry.perspective {
                        Image(systemName: "circle.circle")
                    } else if perspective.referencedBy.contains(entry.perspective) {
                        Image(systemName: "xmark.circle")
                    } else if perspective.references.contains(entry.perspective) {
                        Image(systemName: "checkmark.circle")
                    } else {
                        Image(systemName: "circle")
                    }
                    Text(entry.text)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    guard perspective != entry.perspective, !perspective.referencedBy.contains(entry.perspective) else { return }
                    if perspective.references.contains(entry.perspective) {
                        perspective.references.removeAll(where: { $0 == entry.perspective })
                    } else {
                        perspective.references.append(entry.perspective)
                    }
                }
            }
        }
    }
}

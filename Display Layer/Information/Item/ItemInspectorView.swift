//
//  ItemInspectorView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 28.07.24.
//

import Grisu
import SwiftUI

struct ItemInspectorView: View {
    // MARK: Properties

    @Environment(\.document) var document
    @Bindable var item: Information.Item
    @State var perspective: Structure.Perspective

    // MARK: Computed Properties

    // TODO: Später mal nachschauen, wie die neue Funktion zur Formattierung der ChildrenViews genutzt werden kann, um den Inspektor als Liste mit DisclosureGroups oder als TabView oder in einem eigenen mit Rollen Vertikal rechts.

    var defaultPresentation: Presentation {
        Presentation.vertical(perspective.allAspects.map { aspect in
            if aspect.kind == .drawing {
                Presentation.aspect(aspect.id, appearance: .normal)
            } else {
                Presentation.aspect(aspect.id, appearance: .inspector)
            }
        }, alignment: .leading)
    }

    var perspectivePresentation: Presentation? {
        perspective.representation(layout: .item)?.presentation
    }

    // MARK: Content

    var body: some View {
        Section(header: Text(perspective.description)) {
            PresentationView(presentation: perspectivePresentation ?? defaultPresentation, item: item)
        }
    }
}

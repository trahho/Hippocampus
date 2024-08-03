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
    @State var role: Structure.Role

    // MARK: Computed Properties

    // TODO: Später mal nachschauen, wie die neue Funktion zur Formattierung der ChildrenViews genutzt werden kann, um den Inspektor als Liste mit DisclosureGroups oder als TabView oder in einem eigenen mit Rollen Vertikal rechts.

    var defaultPresentation: Presentation {
        Presentation.vertical(role.allAspects.map { aspect in
            if aspect.kind == .drawing {
                Presentation.aspect(aspect.id, appearance: .normal)
            } else {
                Presentation.aspect(aspect.id, appearance: .inspector)
            }
        }, alignment: .leading)
    }

    var rolePresentation: Presentation? {
        role.representation(layout: .item)?.presentation
    }

    // MARK: Content

    var body: some View {
        Section(header: Text(role.description)) {
            PresentationView(presentation: rolePresentation ?? defaultPresentation, item: item)
        }
    }
}

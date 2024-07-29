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

    // MARK: Content

    // TODO: Später mal nachschauen, wie die neue Funktion zur Formattierung der ChildrenViews genutzt werden kann, um den Inspektor als Liste mit DisclosureGroups oder als TabView oder in einem eigenen mit Rollen Vertikal rechts.

    var body: some View {
        EmptyView()
    }
}

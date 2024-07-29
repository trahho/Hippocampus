//
//  TreeView.ItemPresentationView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.07.24.
//

import Grisu
import SwiftUI



struct ItemPresentationView: View {
    // MARK: Properties

    @Environment(\.structure) var structure
    @State var item: Information.Item
    @State var role: Structure.Role
    @State var presentation: Presentation?
    @State var layout: Presentation.Layout

    // MARK: Computed Properties

    var rolePresentation: Presentation? {
        role.representation(layout: layout)?.presentation
    }

    // MARK: Content

    var body: some View {
        Group {
            if let presentation = presentation ?? rolePresentation {
                PresentationView(presentation: presentation, item: item)
                    .sensitive
            } else {
                Image(systemName: "questionmark.square.dashed")
            }
        }
    }
}

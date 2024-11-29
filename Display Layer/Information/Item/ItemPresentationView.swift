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
    @State var perspective: Structure.Perspective
    @State var presentation: Presentation?
    @State var layout: Presentation.Layout

    // MARK: Computed Properties

    var perspectivePresentation: Presentation? {
        perspective.representation(layout: layout)?.presentation
    }

    // MARK: Content

    var body: some View {
        Group {
            if let presentation = presentation ?? perspectivePresentation {
                PresentationView(presentation: presentation, item: item)
//                    .sensitive
            } else {
                Image(systemName: "questionmark.square.dashed")
            }
        }
    }
}

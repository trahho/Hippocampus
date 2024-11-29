//
//  PerspectiveEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 14.06.24.
//

import Grisu
import SwiftUI

struct PerspectivesView: View {
    // MARK: Properties

    @Environment(\.document) var document
    @State var perspective: Structure.Perspective.ID?
    @State var expanded: Expansions = .init()


    // MARK: Computed Properties

    var perspectives: [Structure.Perspective] {
        document.structure.perspectives
            .filter { $0 != Structure.Perspective.Statics.same }
            .sorted(by: { $0.name.localized($0.isLocked) < $1.name.localized($1.isLocked) })
    }

    // MARK: Content

    var body: some View {
        NavigationSplitView {
            List(perspectives, selection: $perspective) { perspective in
                Text(perspective.name.localized(perspective.isLocked))
            }
        } detail: {
            if let id = perspective, let perspective = document[Structure.Perspective.self, id] {
                PerspectiveEditView(perspective: perspective)
                    .id(id)
            } else {
                EmptyView()
            }
        }
        .toolbar {
            Button {
                let perspective = document(Structure.Perspective.self)
                self.perspective = perspective.id
            } label: {
                Image(systemName: "plus")
            }
//            #if os(OSX)
//                Button {
//                    var result = """
//                    extension Structure.Perspective {
//                        typealias Perspective = Structure.Perspective
//                        typealias Aspect = Structure.Aspect
//                        typealias Particle = Structure.Particle
//
//
//                    """
//                    result += "\tstatic var statics: [Perspective] = [.same, "
//                    result += document.structure.perspectives
//                        .filter { $0 != Structure.Perspective.same }
//                        .sorted(by: { $0.name < $1.name })
//                        .map { ".\($0.name)" }
//                        .joined(separator: ", ")
//                    result += "]\n\n"
//
//                    result += Structure.Perspective.same.sourceCode(tab: 0, inline: false, document: document) + "\n"
//                    for perspective in document.structure.perspectives
//                        .filter({ $0 != Structure.Perspective.same })
//                        .sorted(by: { $0.name < $1.name })
//                    {
//                        result += perspective.sourceCode(tab: 0, inline: false, document: document) + "\n"
//                    }
//                    result += "}"
//                    let pasteboard = NSPasteboard.general
//                    pasteboard.clearContents()
//                    pasteboard.setString(result, forType: .string)
//                } label: {
//                    Image(systemName: "function")
//                }
//
//            #endif
        }
    }
}

//#Preview {
//    @Previewable @State var document = HippocampusApp.previewDocument
//    return PerspectivesView()
//        .environment(document)
//}

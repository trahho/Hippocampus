//
//  PerspectiveEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.06.24.
//

import Grisu
import SwiftUI

struct PerspectiveEditView: View {
    // MARK: Properties

    @Environment(\.document) var document
    @State var perspective: Structure.Perspective
    @State var expanded: Expansions = .init()
    @State var representation: Structure.Perspective.Representation?

    // MARK: Computed Properties

    var conformation: [Structure.Perspective] {
        perspective.perspectives
            .sorted(by: { $0.description < $1.description })
    }

    // MARK: Content

    var body: some View {
        Form {
            Section("Perspective", isExpanded: $expanded) {
                TextField("Name", text: $perspective.name)
                LabeledContent {
                    DisclosureGroup {
                        SelectPerspectivesSheet(perspective: $perspective)
                    } label: {
                        Text(perspective.perspectives.map { $0.description}.joined(separator: ", "))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                } label: {
                    Text("Perspectives")
                }
                LabeledContent {
                    DisclosureGroup {
                        SelectReferencesSheet(perspective: $perspective)
                    } label: {
                        Text(perspective.references.map { $0.description }.joined(separator: ", "))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                } label: {
                    Text("References")
                }
            }

            Section("Aspects", isExpanded: $expanded) {
                ListEditView($perspective.aspects) { aspect in
                    Text("\(aspect.id)")
                        .font(.caption)
                    TextField("Name", text: aspect.name)
                    EnumPicker("Kind", selection: aspect.kind)
//                    Toggle("Computed", isOn: aspect.exportCodedComputed)
//                        .disabled(aspect.codedComputation.wrappedValue != nil)
                }
            }

            Section("Particles", isExpanded: $expanded) {
                ListEditView($perspective.particles) { particle in
                    Text("\(particle.id)")
                        .font(.caption)
                    TextField("Name", text: particle.name)
                    Section("Aspects") {
                        ListEditView(particle.aspects) { aspect in
                            Text("\(aspect.id)")
                                .font(.caption)
                            TextField("Name", text: aspect.name)
                            EnumPicker("Kind", selection: aspect.kind)
//                            Toggle("Computed", isOn: aspect.exportCodedComputed)
//                                .disabled(aspect.codedComputation.wrappedValue != nil)

                        }
                    }
                }
            }

            Section("Views", isExpanded: $expanded) {
                ListEditView($perspective.representations) { representation in
                    LabeledContent("Name") { Text(representation.name.wrappedValue) }
                    HStack {
                        PresentationView(presentation: representation.presentation.wrappedValue, item: nil)
                            .sensitive
                        Image(systemName: "square.and.pencil")
                            .onTapGesture {
                                self.representation = representation.wrappedValue
                            }
                    }
                }
                .sheet(item: $representation) { representation in
                    EditRepresentationSheet(perspective: perspective, representation: representation)
                }
            }

            Section("Source code", isExpanded: $expanded) {
                Text(perspective.sourceCode(tab: 0, inline: false, document: document))
                    .font(.caption)
                    .textSelection(.enabled)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .formStyle(.grouped)
        .onAppear {
            if perspective.isStatic {
                perspective.isLocked = false
                perspective.aspects.forEach { $0.isLocked = false }
            }
        }
        .onDisappear {
            if perspective.isStatic {
                perspective.isLocked = true
                perspective.aspects.forEach { $0.isLocked = true }
            }
        }
    }
}
//
//#Preview {
//    PerspectiveEditView(perspective: Structure.Perspective.hierarchical)
//        .environment(HippocampusApp.previewDocument)
//}

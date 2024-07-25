//
//  RoleEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.06.24.
//

import Grisu
import SwiftUI

struct RoleEditView: View {
    // MARK: Properties

    @Environment(\.document) var document
    @State var role: Structure.Role
    @State var expanded: Expansions = .init()
    @State var representation: Structure.Role.Representation?

    // MARK: Computed Properties

    var conformation: [Structure.Role] {
        role.roles.sorted(by: { $0.name.localized($0.isLocked) < $1.name.localized($1.isLocked) })
    }

    // MARK: Content

    var body: some View {
        Form {
            Section("Role", isExpanded: $expanded) {
                TextField("Name", text: $role.name)
                LabeledContent {
                    DisclosureGroup {
                        SelectRolesSheet(role: $role)
                    } label: {
                        Text(role.roles.map { $0.name.localized($0.isLocked) }.joined(separator: ", "))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                } label: {
                    Text("Roles")
                }
                LabeledContent {
                    DisclosureGroup {
                        SelectReferencesSheet(role: $role)
                    } label: {
                        Text(role.references.map { $0.name.localized($0.isLocked) }.joined(separator: ", "))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                } label: {
                    Text("References")
                }
            }

            Section("Aspects", isExpanded: $expanded) {
                ListEditView($role.aspects) { aspect in
                    Text("\(aspect.id)")
                        .font(.caption)
                    TextField("Name", text: aspect.name)
                    EnumPicker("Kind", selection: aspect.kind)
                    Toggle("Computed", isOn: aspect.exportCodedComputed)
                        .disabled(aspect.codedComputation.wrappedValue != nil)
                }
            }

            Section("Particles", isExpanded: $expanded) {
                ListEditView($role.particles) { particle in
                    Text("\(particle.id)")
                        .font(.caption)
                    TextField("Name", text: particle.name)
                    Section("Aspects") {
                        ListEditView(particle.aspects) { aspect in
                            Text("\(aspect.id)")
                                .font(.caption)
                            TextField("Name", text: aspect.name)
                            EnumPicker("Kind", selection: aspect.kind)
                            Toggle("Computed", isOn: aspect.exportCodedComputed)
                                .disabled(aspect.codedComputation.wrappedValue != nil)

                        }
                    }
                }
            }

            Section("Views", isExpanded: $expanded) {
                ListEditView($role.representations) { representation in
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
                    EditRepresentationSheet(role: role, representation: representation)
                }
            }

            Section("Source code", isExpanded: $expanded) {
                Text(role.sourceCode(tab: 0, inline: false, document: document))
                    .font(.caption)
                    .textSelection(.enabled)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .formStyle(.grouped)
        .onAppear {
            if role.isStatic {
                role.isLocked = false
                role.aspects.forEach { $0.isLocked = false }
            }
        }
        .onDisappear {
            if role.isStatic {
                role.isLocked = true
                role.aspects.forEach { $0.isLocked = true }
            }
        }
    }
}

#Preview {
    RoleEditView(role: Structure.Role.hierarchical)
        .environment(HippocampusApp.previewDocument)
}

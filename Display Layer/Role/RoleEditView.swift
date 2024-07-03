//
//  RoleEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.06.24.
//

import Grisu
import SwiftUI

struct RoleEditView: View {
    @Environment(Document.self) var document
    @State var role: Structure.Role
    @State var expanded: Expansions = .init()
    @State var representation: Structure.Role.Representation?

    var conformation: [Structure.Role] {
        role.roles.sorted(by: { $0.name.localized($0.isStatic) < $1.name.localized($1.isStatic) })
    }

 

    var body: some View {
        Form {
            Section("Role", isExpanded: $expanded) {
                Text("\(role.id)")
                    .font(.caption)
                TextField("Name", text: $role.name)
                LabeledContent {
                    DisclosureGroup {
                        SelectRolesSheet(role: $role)
                    } label: {
                        Text(role.roles.map { $0.name.localized($0.isStatic) }.joined(separator: ", "))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                } label: {
                    Text("Roles")
                }
                LabeledContent {
                    DisclosureGroup {
                        SelectReferencesSheet(role: $role)
                    } label: {
                        Text(role.references.map { $0.name.localized($0.isStatic) }.joined(separator: ", "))
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
                    Toggle("Computed", isOn: aspect.computed)
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
                            Toggle("Computed", isOn: aspect.computed)
                        }
                    }
                }
            }

            Section("Views", isExpanded: $expanded) {
                ListEditView($role.representations) { representation in
                    LabeledContent("Name") { Text(representation.name.wrappedValue) }
                    HStack {
                        PresentationView(presentation: representation.presentation.wrappedValue, item: nil)
                            .id(UUID())
                        Image(systemName: "square.and.pencil")
                            .onTapGesture {
                                self.representation = representation.wrappedValue
                            }
                    }
                }
                .sheet(item: $representation) { representation in
                    EditRepresentationSheet(role: role, representation: representation)
                }

                Section("Source code", isExpanded: $expanded) {
                    Text(role.sourceCode)
                        .font(.caption)
                        .textSelection(.enabled)
                }
            }
        }
        .formStyle(.grouped)
    }

    struct EditRepresentationSheet: View {
        @State var role: Structure.Role
        @State var representation: Structure.Role.Representation
        var body: some View {
            Form {
                TextField("Name", text: $representation.name)
                PresentationEditView(role: role, presentation: $representation.presentation)
                PresentationView(presentation: representation.presentation, item: Information.Item())
                    .id(UUID())
            }
            .formStyle(.grouped)
            .frame(minWidth: 500, minHeight: 600)
        }
    }
}

#Preview {
    RoleEditView(role: Structure.Role.hierarchical)
        .environment(HippocampusApp.editStaticRolesDocument)
}

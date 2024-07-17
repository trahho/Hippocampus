//
//  RoleEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.06.24.
//

import Grisu
import SwiftUI

struct RoleEditView: View {
    // MARK: Nested Types

    struct EditRepresentationSheet: View {
        // MARK: Properties

        @Environment(\.document) var document
        @State var role: Structure.Role
        @State var representation: Structure.Role.Representation

        // MARK: Content

        var body: some View {
            VStack(alignment: .leading) {
//                Form {
                TextField("Name", text: $representation.name)
//                }
//                .formStyle(.grouped)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 300))], spacing: 10) {
                    ForEach(Presentation.Layout.allCases, id: \.self) { layout in
                        Text(layout.description)
                            .background{
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundStyle(representation.layouts.contains(layout) ? Color.accentColor : Color.clear)
                            }
                            .onTapGesture {
                                if representation.layouts.contains(layout) {
                                    representation.layouts.remove(item: layout)
                                } else {
                                    representation.layouts.append(layout)
                                }
                            }
                    }
                }
               
                PresentationEditView(role: role, presentation: $representation.presentation)
                PresentationView(presentation: representation.presentation, item: Information.Item())
                    .id(UUID())
                Spacer()
            }
            .padding()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(minWidth: 1500, minHeight: 900)
        }
    }

    // MARK: Properties

    @Environment(\.document) var document
    @State var role: Structure.Role
    @State var expanded: Expansions = .init()
    @State var representation: Structure.Role.Representation?

    // MARK: Computed Properties

    var conformation: [Structure.Role] {
        role.roles.sorted(by: { $0.name.localized($0.isStatic) < $1.name.localized($1.isStatic) })
    }

    // MARK: Content

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
            }

            Section("Source code", isExpanded: $expanded) {
                Text(role.sourceCode(tab: 0, inline: false, document: document))
                    .font(.caption)
                    .textSelection(.enabled)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .formStyle(.grouped)
    }
}

#Preview {
    RoleEditView(role: Structure.Role.hierarchical)
        .environment(HippocampusApp.editStaticRolesDocument)
}

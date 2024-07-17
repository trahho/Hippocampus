//
//  FilterEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 10.07.24.
//

import Grisu
import SwiftUI

struct FilterEditView: View {
    // MARK: Nested Types

    struct SelectFiltersSheet: View {
        // MARK: Nested Types

        struct Entry: Identifiable, Hashable {
            // MARK: Properties

            let item: Structure.Filter
            let filter: Structure.Filter

            // MARK: Computed Properties

            var id: Structure.Filter.ID { filter.id }
            var text: String { filter.name.localized(filter.isStatic) }

            var children: [Entry]? {
                let result = filter.subFilters
//                    .filter { !$0.conforms(to: item) }
                    .sorted(by: { $0.name.localized($0.isStatic) < $1.name.localized($1.isStatic) })
                    .map { Entry(item: item, filter: $0) }
                return result.isEmpty ? nil : result
            }
        }

        // MARK: Properties

        @Environment(\.document) var document
        @Binding var filter: Structure.Filter

        // MARK: Computed Properties

        var roots: [Entry] {
            document.structure.filters
                .filter { $0.superFilters.isEmpty && $0 != filter }
                .sorted(by: { $0.name.localized($0.isStatic) < $1.name.localized($1.isStatic) })
                .map { Entry(item: filter, filter: $0) }
        }

        // MARK: Content

        var body: some View {
            List(roots, children: \.children) { entry in
                HStack {
                    if filter == entry.filter {
                        Image(systemName: "circle.circle")
                    } else if filter.subFilters.contains(entry.filter) {
                        Image(systemName: "xmark.circle")
                    } else if filter.superFilters.contains(entry.filter) {
                        Image(systemName: "checkmark.circle")
                    } else {
                        Image(systemName: "circle")
                    }
                    Text(entry.text)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    guard filter != entry.filter, !filter.subFilters.contains(entry.filter) else { return }
                    if filter.superFilters.contains(entry.filter) {
                        filter.superFilters.removeAll(where: { $0 == entry.filter })
                    } else {
                        filter.superFilters.append(entry.filter)
                    }
                }
            }
        }
    }

    // MARK: Properties

    @Environment(\.document) var document
    @State var filter: Structure.Filter
    @State var expanded: Expansions = .init()

    // MARK: Content

//    @State var representation: Structure.Role.Representation?

//    var conformation: [Structure.Role] {
//        role.roles.sorted(by: { $0.name.localized($0.isStatic) < $1.name.localized($1.isStatic) })
//    }

    var body: some View {
        Form {
            Section("Filter", isExpanded: $expanded) {
                Text("\(filter.id)")
                    .font(.caption)
                TextField("Name", text: $filter.name)
                LabeledContent {
                    DisclosureGroup {
                        SelectFiltersSheet(filter: $filter)
                    } label: {
                        Text(filter.superFilters.map { $0.name.localized($0.isStatic) }.joined(separator: ", "))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                } label: {
                    Text("Parents")
                }
            }
            Section("Condition", isExpanded: $expanded) {
                ConditionEditView(condition: $filter.condition)
            }

            //                LabeledContent {
            //                    DisclosureGroup {
            //                        SelectReferencesSheet(role: $role)
            //                    } label: {
            //                        Text(role.references.map { $0.name.localized($0.isStatic) }.joined(separator: ", "))
            //                            .frame(maxWidth: .infinity, alignment: .trailing)
            //                    }
            //                } label: {
            //                    Text("References")
            //                }
            //            }

            //            Section("Aspects", isExpanded: $expanded) {
            //                ListEditView($role.aspects) { aspect in
            //                    Text("\(aspect.id)")
            //                        .font(.caption)
            //                    TextField("Name", text: aspect.name)
            //                    EnumPicker("Kind", selection: aspect.kind)
            //                    Toggle("Computed", isOn: aspect.computed)
            //                }
            //            }

            //            Section("Particles", isExpanded: $expanded) {
            //                ListEditView($role.particles) { particle in
            //                    Text("\(particle.id)")
            //                        .font(.caption)
            //                    TextField("Name", text: particle.name)
            //                    Section("Aspects") {
            //                        ListEditView(particle.aspects) { aspect in
            //                            Text("\(aspect.id)")
            //                                .font(.caption)
            //                            TextField("Name", text: aspect.name)
            //                            EnumPicker("Kind", selection: aspect.kind)
            //                            Toggle("Computed", isOn: aspect.computed)
            //                        }
            //                    }
            //                }
            //            }

            //            Section("Views", isExpanded: $expanded) {
            //                ListEditView($role.representations) { representation in
            //                    LabeledContent("Name") { Text(representation.name.wrappedValue) }
            //                    HStack {
            //                        PresentationView(presentation: representation.presentation.wrappedValue, item: nil)
            //                            .id(UUID())
            //                        Image(systemName: "square.and.pencil")
            //                            .onTapGesture {
            //                                self.representation = representation.wrappedValue
            //                            }
            //                    }
            //                }
            //                .sheet(item: $representation) { representation in
            //                    EditRepresentationSheet(role: role, representation: representation)
            //                }
            //
            Section("Source code", isExpanded: $expanded) {
                Text(filter.sourceCode(tab: 0, inline: false, document: document))
                    .font(.caption)
                    .textSelection(.enabled)
            }
            //            }
        }
        .formStyle(.grouped)
    }
}

// #Preview {
//    FilterEditView(role: Structure.Filter.)
//        .environment(HippocampusApp.editStaticRolesDocument)
// }

//
//  FilterEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 10.07.24.
//

import Grisu
import SwiftUI

struct FilterEditView: View {
    // MARK: Properties

    @Environment(\.document) var document
    @State var filter: Structure.Filter
    @State var expanded: Expansions = .init()
    @State var representation: Structure.Filter.Representation?
    @State var isStatic: Bool = false
    

    // MARK: Content

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
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 10) {
                    ForEach(Presentation.Layout.allCases, id: \.self) { layout in
                        Text(layout.description)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundStyle(filter.layouts.contains(layout) ? Color.accentColor : Color.clear)
                            }
                            .onTapGesture {
                                if filter.layouts.contains(layout) {
                                    filter.layouts.remove(item: layout)
                                } else {
                                    filter.layouts.append(layout)
                                }
                            }
                    }
                }
            }
            
            Section("Roles", isExpanded: $expanded) {
                SelectRolesSheet(filter: $filter)
            }

            Section("Condition", isExpanded: $expanded) {
                ConditionEditView(condition: $filter.condition)
            }

            Section("Views", isExpanded: $expanded) {
                ListEditView($filter.representations) { representation in
                    HStack {
                        Text(representation.condition.wrappedValue.sourceCode(tab: 0, inline: true, document: document))
                        Image(systemName: "square.and.pencil")
                            .onTapGesture {
                                self.representation = representation.wrappedValue
                            }
                    }
                }
                .sheet(item: $representation) { representation in
                    EditRepresentationSheet(representation: representation)
                }
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
        .onAppear {
            if filter.isStatic {
                filter.toggleStatic(to: false)
                isStatic = true
            }
        }
        .onDisappear {
            if isStatic {
                filter.toggleStatic(to: true)
            }
        }
        .formStyle(.grouped)
    }
}

// #Preview {
//    FilterEditView(role: Structure.Filter.)
//        .environment(HippocampusApp.editStaticRolesDocument)
// }

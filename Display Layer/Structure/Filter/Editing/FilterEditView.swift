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
                if filter.isLocked {
                    Toggle("Is locked", isOn: $filter.isLocked)
                }
                Text("Is static \(filter.isStatic ? "yes" : "no")")
                TextField("Name", text: $filter.name)
                LabeledContent {
                    DisclosureGroup {
                        SelectFiltersSheet(filter: $filter)
                    } label: {
                        Text(filter.superFilters.map { $0.name.localized($0.isLocked) }.joined(separator: ", "))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                } label: {
                    Text("Parents")
                }

                SelectorView(data: Presentation.Layout.allCases, selection: $filter.layouts) { Text($0.description) }
//                LazyHGrid(rows: [GridItem(.flexible())], spacing: 10) {
//                    ForEach(Presentation.Layout.allCases, id: \.self) { layout in
//                        Text(layout.description)
//                            .padding()
//                            .background {
//                                RoundedRectangle(cornerRadius: 4)
//                                    .foregroundStyle(filter.layouts.contains(layout) ? Color.accentColor : Color.clear)
//                            }
//                            .onTapGesture {
//                                if filter.layouts.contains(layout) {
//                                    filter.layouts.remove(item: layout)
//                                } else {
//                                    filter.layouts.append(layout)
//                                }
//                            }
//                    }
//                }
            }

            Section("Perspectives", isExpanded: $expanded) {
                SelectPerspectivesSheet(filter: $filter)
            }

            Section("Condition", isExpanded: $expanded) {
                ConditionEditView(condition: $filter.condition)
            }

            Section("Sorting", isExpanded: $expanded) {
                ListEditView($filter.orders) { $order in
                    ListEditView(Binding(get: {
                        if case let .multiSorted(sorters) = order {
                            sorters
                        } else {
                            [order]
                        }
                    }, set: { newValue in
                        if newValue.count == 1 {
                            order = newValue.first!
                        } else {
                            order = .multiSorted(newValue)
                        }
                    })) { $order in
                        HStack(alignment: .center) {
                            if case let .sorted(aspectId, ascending, form) = order {
                                AspectSelector(schräg: Binding(get: { (aspectId, form) }, set: { order = .sorted($0.aspect, ascending: ascending, form: $0.form) }))
                                Toggle(isOn: Binding(get: { ascending }, set: { order = .sorted(aspectId, ascending: $0) })) {
                                    Text("Ascending")
                                }
                            } else {
                                Text("Wrong ;-)")
                            }
                            Spacer()
                            Image(systemName: "line.3.horizontal")
                        }

                        .frame(maxWidth: .infinity)
                    }
                }
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

            Section("Source code", isExpanded: $expanded) {
                Text(filter.sourceCode(tab: 0, inline: false, document: document))
                    .font(.caption)
                    .textSelection(.enabled)
            }
            //            }
        }
        .onAppear {
            if filter.isStatic {
                filter.isLocked = false
            }
        }
        .onDisappear {
            if filter.isStatic {
                filter.isLocked = true
            }
        }
        .formStyle(.grouped)
    }
}

// #Preview {
//    FilterEditView(perspective: Structure.Filter.)
//        .environment(HippocampusApp.editStaticPerspectivesDocument)
// }

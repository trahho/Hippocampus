//
//  Design.ListView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.04.23.
//

import SwiftUI

struct Design_ListView: View {
    // MARK: Nested Types

    struct Item: Identifiable, Hashable {
        // MARK: Properties

        let filter: Structure.Filter

        // MARK: Computed Properties

        var id: Structure.Filter.ID { filter.id }

        var children: [Item]? {
            guard !filter.subFilters.isEmpty else { return nil }
            return filter.subFilters.sorted(by: { $0.description < $1.description }).map { Item(filter: $0) }
        }
    }

    // MARK: Properties

    @Environment(\.document) var document
    @State var selection: Structure.Filter.ID?

    // MARK: Computed Properties

    var filters: [Item] {
        document.structure.filters.filter { $0.superFilters.isEmpty }.sorted(by: { $0.description < $1.description }).map { Item(filter: $0) }
    }

    // MARK: Content

    var body: some View {
        List(filters, id: \.id, children: \.children, selection: $selection) { filter in
            Text(filter.filter.name)
        }
        .listStyle(.sidebar)
    }

//    var body: some View {
    ////        List (selection: $selection){
//        List {
//            ForEach(1 ..< 10) { number in
//                DisclosureGroup {
//                    ForEach(1 ..< 10) { i in
//                        Text("\(i)")
//                            .font(.myText)
//                            .padding()
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .listRowInsets(EdgeInsets())
//                            .background(selection == i ? Color.blue.opacity(0.5).cornerRadius(8) : Color.clear.cornerRadius(0))
    ////                            .background {
    ////                                if i == selection {
    ////                                    RoundedRectangle(cornerRadius: 10, style: .circular)
    ////                                        .padding()
    ////                                        .foregroundColor(.red)
    ////                                }
    ////                            }
//                    }
//                } label: {
//                    Text("\(number)")
//                        .font(.myHeader)
//                }
//
//                .listRowSeparator(.hidden)
//            }
//        }
    ////        }
//        .listStyle(.plain)
//    }
}

struct Design_ListView_Previews: PreviewProvider {
    static var previews: some View {
        Design_ListView()
    }
}

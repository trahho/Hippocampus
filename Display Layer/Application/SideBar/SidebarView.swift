//
//  SidebarView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.03.23.
//

import Foundation
import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var navigation: Navigation
    @EnvironmentObject var document: Document
    @State var editItem: Presentation.Object?
    @State var selection: Presentation.Query?

    var groups: [Presentation.Group] {
        document.presentation.groups
            .filter { $0.isTop }
            .sorted { $0.name < $1.name }
    }

    var queries: [Presentation.Query] {
        document.presentation.queries
            .filter { $0.isTop }
            .sorted { $0.name < $1.name }
    }

    @ViewBuilder var content: some View {
        ForEach(groups) { group in
            GroupView(group: group, editItem: $editItem)
        }
        ForEach(queries) { query in
            QueryView(query: query, editItem: $editItem)
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            List(selection: $selection) {
                content
                    .listRowSeparator(.hidden)
            }
            .listStyle(.sidebar)
            .sheet(item: $editItem) { item in
                EditView(groupItem: item)
            }
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static let document = HippocampusApp.previewDocument()
    static let navigation = Navigation()
    static var previews: some View {
        SidebarView()
            .environmentObject(document)
            .environmentObject(navigation)
    }
}

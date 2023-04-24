//
//  SidebarView.GroupView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.04.23.
//

import Foundation
import SwiftUI

extension SidebarView {
    struct GroupView: View {
        @ObservedObject var group: Presentation.Group
        @Binding var editItem: Presentation.Object?
        
        var groups: [Presentation.Group] {
            group.subGroups.sorted {
                $0.name < $1.name
            }
        }
        
        var queries: [Presentation.Query] {
            group.queries.sorted {
                $0.name < $1.name
            }
        }
        
        var body: some View {
            DisclosureGroup {
                ForEach(groups) { group in
                    GroupView(group: group, editItem: $editItem)
                }
                ForEach(queries) { query in
                    QueryView(query: query, editItem: $editItem)
                }
            } label: {
                HStack {
                    GroupIconView(group: group)
                    GroupNameView(group: group)
                }
                .padding([.leading], 0)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        print("Edit Group")
                        editItem = group
                    } label: {
                        Label("_editGroups", systemImage: "tray.and.arrow.down")
                    }
                }
            }
        }
    }
}

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
                    GroupView(group: group)
                }
                ForEach(queries) { query in
                    QueryView(query: query)
                }
            } label: {
                HStack {
                    Image(systemName: group.subGroups.isEmpty ? "tray" : "tray.2")
                    group.textView
                }
                .padding([.leading], 0)
            }
        }
    }
}

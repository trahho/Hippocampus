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
            GroupView(group: group)
        }
        ForEach(queries) { query in
            QueryView(query: query)
        }
    }
    
    var body: some View {
        List {
            content
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
   
}

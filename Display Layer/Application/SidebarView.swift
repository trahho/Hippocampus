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
    
    struct QueryView: View {
        @EnvironmentObject var navigation: Navigation
        @ObservedObject var query: Presentation.Query
        
        var body: some View {
            HStack {
                Image(systemName: "doc.text.magnifyingglass")
                query.textView
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                navigation.query = query
            }
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(query == navigation.query ? Color.accentColor : Color.clear)
            }
        }
    }
    
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

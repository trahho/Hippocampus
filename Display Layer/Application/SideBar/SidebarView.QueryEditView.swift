//
//  Sidebar.EditGroupingView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 24.04.23.
//

import SwiftUI

extension SidebarView {
    struct QueryEditView: View {
        @EnvironmentObject var document: Document
        @ObservedObject var groupItem: Presentation.Object
        @State var name: String = ""
        
        var query: Presentation.Query? {
            groupItem as? Presentation.Query
        }
        
        var group: Presentation.Group? {
            groupItem as? Presentation.Group
        }
        
        var groups: [Presentation.Group] {
            document.presentation.groups
                .filter { $0.isTop }
                .sorted { $0.name < $1.name }
        }
        
        var body: some View {
            VStack(alignment: .center) {
                Group {
                    if let query { QueryNameView(query: query) }
                    if let group { GroupNameView(group: group) }
                }
                .font(.myTitle)
                
                TextField("_Group_Name", text: $name)
                    .onSubmit {
                        if let query { query.name = name }
                        if let group { group.name = name }
                    }
                List {
                    ForEach(groups) { group in
                        RowView(rowItem: group, groupItem: groupItem)
                    }
                }
                .listStyle(.plain)
            }
            .onAppear {
                name = group?.name ?? query?.name ?? ""
            }
        }
    }
}

extension SidebarView.QueryEditView {
    struct RowView: View {
        @ObservedObject var rowItem: Presentation.Group
        @ObservedObject var groupItem: Presentation.Object
        
        var groups: [Presentation.Group] {
            rowItem.subGroups.sorted {
                $0.name < $1.name
            }
        }
        
        var query: Presentation.Query? {
            groupItem as? Presentation.Query
        }
        
        var group: Presentation.Group? {
            groupItem as? Presentation.Group
        }
        
        var isContained: Bool {
            if let group { return group.superGroups.contains(rowItem) }
            if let query { return query.groups.contains(rowItem) }
            return false
        }
        
        var isCycle: Bool {
            guard let group else { return false }
            return rowItem.allSuperGroups.contains(group)
        }
        
        var isSame: Bool {
            guard let group else { return false }
            return group == rowItem
        }
        
        func switchState() {
            print("Switch")
            guard !isCycle, !isSame else { return }
            if let group {
                if isContained {
                    group.superGroups.remove(rowItem)
                } else {
                    group.superGroups.insert(rowItem)
                }
            }
            if let query {
                if isContained {
                    print("Removed")
                    query.groups.remove(rowItem)
                } else {
                    print("Added")
                    query.groups.insert(rowItem)
                }
            }
        }
        
        @ViewBuilder var label: some View {
            HStack {
                Image(systemName: isSame ? "circle.circle" : isCycle ? "xmark.circle" : isContained ? "checkmark.circle.fill" : "circle")
                GroupIconView(group: rowItem)
                GroupNameView(group: rowItem)
            }
            .padding([.leading], 0)
            .contentShape(Rectangle())
            .onTapGesture {
                switchState()
            }
        }
        
        var body: some View {
            if groups.isEmpty {
                label
            } else {
                DisclosureGroup {
                    ForEach(groups) { group in
                        RowView(rowItem: group, groupItem: groupItem)
                    }
                } label: {
                    label
                }
            }
        }
    }
}

struct Sidebar_EditGroupingView_Previews: PreviewProvider {
    static let document = HippocampusApp.previewDocument()
    static let navigation = Navigation()

    static var previews: some View {
        SidebarView.QueryEditView(groupItem: Presentation.Query.notes)
            .environmentObject(document)
            .environmentObject(navigation)
    }
}

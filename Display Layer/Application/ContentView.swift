//
//  ContentView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var document: Document
    @EnvironmentObject var navigation: Navigation

    @ToolbarContentBuilder
    func toolbar() -> some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Menu {
                ForEach(document.roles
//                    .filter(\.canBeCreated)
                    .sorted(by: { $0.roleDescription < $1.roleDescription })) { role in
                    Button {
                        let node = document.information.createNode(roles: [role])
                        navigation.showItem(item: node, roles: [role])
                    } label: {
                        role.textView
                    }
                }
            } label: {
                Label("Add", systemImage: "plus")
            }
        }
        ToolbarItemGroup(placement: .navigation) {
            if let _ = navigation.detail {
                Button {
                    navigation.moveBack()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
    }

    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            DetailView()
        }
        .toolbar(content: toolbar)

//        NavigationSplitView {
//            List(document.queries.asArray.sorted(by: { $0.name < $1.name }), id: \.self, selection: $navigation.query) { query in
        ////                NavigationLink(value: Navigation.Detail.queryContent(query)) {
//                    Text(query.name)
//                        .font(.myText)
//                        .onTapGesture {
//                            navigation.details.append(.queryContent(query))
//                        }
        ////                }
//            }
//        } detail: {
//            NavigationStack(path: $navigation.details) {
//                Text("Nix")
//                    .navigationDestination(for: Navigation.Detail.self) { detail in
//                        Text("Detail")
//                    }
//            }
//        }

//        NavigationStack(path: $navigation.details) {
//            ListView(information: document.information, query: Structure.Query.notes)
//                .environmentObject(navigation)
//                //        DrawingView()
//
//                .navigationDestination(for: Information.Item.self) { item in
//                    NoteView(editable: true, note: item)
//                }
//                .navigationDestination(for: Information.Node.self) { item in
//                    NoteView(editable: true, note: item)
//                }
//        }
    }
}

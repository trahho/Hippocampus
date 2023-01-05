//
//  ContentView.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 12.11.22.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var information: Information
    @ObservedObject var query: Structure.Query

    @State var addSheetIsPresented = false
    @State var editSheetItem: Structure.Query.Result.Node?
    @State var sortOrder: SortOrder = .forward

    var result: Structure.Query.Result {
        query.apply(to: information)
    }

//    var items: [Mind.Idea] {
//        conclusion.ideas.values
//            .sorted(using: Aspect.Comparator(order: .forward, aspect: Perspective.note.name))
//    }

    var body: some View {
        VStack(alignment: .leading) {
            Button {
                addSheetIsPresented.toggle()
            } label: {
                Text("Add")
            }
            let nameAspect = Structure.Role.note.name
            let items = result.nodes.asArray
                .sorted(by: { a, b in
                    a.item[String.self, nameAspect] ?? "" < b.item[String.self, nameAspect] ?? ""
                })
//                .sorted(using: Aspect.Comparator(order: sortOrder, aspect: Perspective.note.name))
            ScrollView {
                ForEach(items) { item in
                    nameAspect.view(for: item.item, editable: false)
                        .padding(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            editSheetItem = item
                        }
                }
            }
            .navigationDestination(for: Structure.Query.Result.Node.self) { note in
                EditNoteView(modification: information.transaction(), note: note.item as! Information.Node)
            }
        }
        .sheet(isPresented: $addSheetIsPresented) {
            AddNoteView()
        }
        .sheet(item: $editSheetItem) { item in
            EditNoteView(modification: information.transaction(), note: item.item as! Information.Node)
        }
    }
}

//
// struct ContentView: View {
//    @EnvironmentObject var consciousness: Consciousness
//
//    var body: some View {
//        ListView()
//    }
// }
//
// struct ContentView_Previews: PreviewProvider {
//    static let consciousness = Consciousness.preview1
//    static var previews: some View {
//        ContentView()
//            .environmentObject(consciousness)
//    }
// }

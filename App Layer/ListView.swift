//
//  ContentView.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 12.11.22.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var information: Information
    @ObservedObject var query: Presentation.Query
    @EnvironmentObject var document: Document
    @EnvironmentObject var navigation: Navigation

    @State var addSheetIsPresented = false
    @State var editSheetItem: Presentation.Query.Result.Node?
    @State var sortOrder: SortOrder = .forward
    @State var refresh: Bool = false

    var result: Presentation.Query.Result {
        query.apply(to: information)
    }

//    let listItem: Structure.Representation = .horizontal([
//        .aspect(Structure.Role.note.name, form: .small, editable: true),
//        .vertical([
//            .aspect(Structure.Role.note.name, form: .small, editable: false),
//            .aspect(Structure.Role.note.text, form: .normal, editable: false)
//        ], alignment: .leading)
//    ], alignment: .center)

    let listItem: Structure.Representation = .vertical([
        .aspect(Structure.Role.global.name, form: .small, editable: false),
        .aspect(Structure.Role.text.text, form: .small, editable: false),
//        .aspect(Structure.Role.note.zeichnung, form: .small, editable: false)
    ], alignment: .leading)

//    var items: [Mind.Idea] {
//        conclusion.ideas.values
//            .sorted(using: Aspect.Comparator(order: .forward, aspect: Perspective.note.name))
//    }

    var body: some View {
        VStack(alignment: .leading) {
            Button {
//                navigation.showItem(document.information.createNode(roles: [Structure.Role.note]))
            } label: {
                Text("Add")
            }
            let nameAspect = Structure.Role.global.name
            let items = result.nodes.asArray
                .sorted(by: { a, b in
                    a.item[String.self, nameAspect] ?? "" < b.item[String.self, nameAspect] ?? ""
                })
//                .sorted(using: Aspect.Comparator(order: sortOrder, aspect: Perspective.note.name))
//            ScrollView {
//                VStack(alignment: .leading) {
            List(items) { item in
//                        NavigationLink(value:item.item) {
                listItem.view(for: item.item, editable: false)
                    .padding(2)
                    .onTapGesture {
//                                    navigation.showItem(item.item)
                    }
                //                                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        }
//                        listItem.view(for: item.item, editable: false)
//                            .padding(2)
//                            .contentShape(Rectangle())
//                            .onTapGesture {
//                                editSheetItem = item
//                            }
//                    }
//                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
//            .navigationDestination(for: Structure.Query.Result.Node.self) { note in
//                EditNoteView(modification: information.transaction().started(), note: note.item as! Information.Node)
//            }
        }
        .sheet(isPresented: $addSheetIsPresented) {
            refresh.toggle()
        } content: {
            NoteView(editable: true)
        }
        .sheet(item: $editSheetItem) {
            refresh.toggle()
        } content: { item in
            NoteView(editable: true, note: item.item)
        }
    }

    func newNote() -> Information.Node {
        let note = Information.Node()
        note[role: Structure.Role.text] = true
        note[role: Structure.Role.drawing] = true
        information.add(note)
        return note
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

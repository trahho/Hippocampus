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
    @State var refresh: Bool = false

    var result: Structure.Query.Result {
        query.apply(to: information)
    }

    let listItem: Structure.Representation = .horizontal([
        .aspect(Structure.Role.note.name, editable: true),
        .vertical([
            .aspect(Structure.Role.note.name, editable: false),
            .aspect(Structure.Role.note.text, editable: false)
        ], alignment: .leading)
    ], alignment: .center)

//    var items: [Mind.Idea] {
//        conclusion.ideas.values
//            .sorted(using: Aspect.Comparator(order: .forward, aspect: Perspective.note.name))
//    }

    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $refresh) {
                Text("Refresh")
            }
            .hidden()
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
                    listItem.view(for: item.item, editable: true)
                        .padding(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            editSheetItem = item
                        }
                }
            }
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
        note[role: Structure.Role.note] = true
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

//
//  ContentView.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 12.11.22.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var consciousness: Consciousness
    @EnvironmentObject var mind: Mind
    @EnvironmentObject var brain: Brain

    @State var addSheetIsPresented = false
    @State var editSheetItem: Mind.Thing?

    var conclusion: Mind.Thought.Conclusion {
        Mind.Thought.notes.think(in: brain)
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
            let items = conclusion.ideas.values
                .sorted(using: Aspect.Comparator(order: .forward, aspect: Perspective.note.name))
            ScrollView {
                ForEach(items) { idea in
                    if case let .string(string) = idea[Perspective.note.name] {
                        NavigationLink(value: idea) {
                            Text(string)
                        }
                        .padding(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            editSheetItem = idea
//                        }
                    }
                }
            }
            .navigationDestination(for: Mind.Idea.self) { note in
                EditNoteView(note: note)
            }
        }
        .sheet(isPresented: $addSheetIsPresented) {
            AddNoteView()
        }
        .sheet(item: $editSheetItem) { item in
            EditNoteView(note: item)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var consciousness: Consciousness

    var body: some View {
        ListView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static let consciousness = Consciousness.preview1
    static var previews: some View {
        ContentView()
            .environmentObject(consciousness)
    }
}

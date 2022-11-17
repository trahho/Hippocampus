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

    var conclusion: Mind.Thought.Conclusion {
        Mind.Thought.notes.think(in: brain)
    }

    var items: [Mind.Idea] {
        conclusion.ideas.values
            .sorted(using: Aspect.Comparator(order: .forward, aspect: Perspective.note.name))
    }

    var body: some View {
        VStack {
            Button {
                addSheetIsPresented.toggle()
            } label: {
                Text("Add")
            }
            List(items) { idea in
                if case let .string(string) = Perspective.note.name[idea] {
                    Text(string)
                }
            }
        }
        .sheet(isPresented: $addSheetIsPresented) {
            AddNoteView()
        }
    }
}

struct EditNoteView: View {
    @ObservedObject var note: Brain.Neuron
    @State var edit = false

    let textAspect = Perspective.note.text

    var text: Binding<String> {
        Binding(get: {
            guard case let  .string(string) = textAspect[note] else {
                return ""
            }
            return string
        }, set: { newValue in textAspect[note] = .string(newValue) })
    }

    var body: some View {
        TextField("Text", text: text)
    }
}

struct ContentView: View {
    @EnvironmentObject var consciousness: Consciousness

    var body: some View {
        ListView()
            .environmentObject(consciousness.memory.brain)
            .environmentObject(consciousness.memory.mind)
            .environmentObject(consciousness.memory.imagination)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let consciousness = Consciousness.preview1
    static var previews: some View {
        ContentView()
            .environmentObject(consciousness)
    }
}

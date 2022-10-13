//
//  ShowAreaView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 31.07.22.
//

import SwiftUI

struct ShowConsciousnessView: View {
    @EnvironmentObject var consciousness: Consciousness

    var brain: Brain {
        consciousness.memory.brain
    }

    var mind: Mind {
        consciousness.memory.mind
    }

    var topic: Mind.Topic {
        mind.topics.values.first!
    }

    var items: [Mind.Idea] {
        topic.ideas
    }

    var body: some View {
        ShowTopicView(topic: topic)
            .onAppear {
                topic.rethink(of: brain)
            }
    }
}

struct ShowTopicView: View {
    @ObservedObject var topic: Mind.Topic

    var items: [Mind.Idea] {
        topic.ideas.sorted(by: { a, b in
            let aspect = Perspective.thema.name
            return aspect[a, ""] < aspect[b, ""]
        })
    }

    var body: some View {
        Form {
            VStack {
                Text("\(topic.ideas.count)")
                ForEach(items) { item in
//                    let aspect = Perspective.thema.name
//                    aspect.sensation(for: item, variation: .normal)
                    EmptyView()
                }
            }
//            Text("3")
//            List {
//                Text("A")
//                Text("B")
//                Text("C")
//            }
        }
//        .frame(width: 400)
    }
}

// struct ShowMemoryView: View {
//    @ObservedObject var brain: Brain
//
//    var body: some View {
//        List(brain.neurons) { neuron in
//            Text("\(neuron.id.hashValue)")
//        }
//    }
// }
//
struct ShowConsciousnessView_Previews: PreviewProvider {
    static var previews: some View {
        ShowConsciousnessView()
            .environmentObject(Consciousness.preview1)
    }
}

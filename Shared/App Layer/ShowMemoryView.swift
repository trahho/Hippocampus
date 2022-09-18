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
            Text("\(topic.ideas.count)")
            List(items) { item in
                let aspect = Perspective.thema.name
                let text: String = aspect[item, ""]
                Text(text)
            }
        }
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

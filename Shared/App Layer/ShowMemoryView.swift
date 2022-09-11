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

    var body: some View {
//        List(Array(brain.neurons.values)) { neuron in
//            let text = neuron[-1] as? String ?? "Nix"
//            Text("\(neuron.id.hashValue) to: \(neuron.axons.count) from: \(neuron.dendrites.count) with: \(text)")
//        }
        Button("Add") {
            brain.add(neuron: Brain.Neuron())
            consciousness.commit()
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

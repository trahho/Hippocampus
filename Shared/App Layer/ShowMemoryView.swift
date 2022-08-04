//
//  ShowAreaView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 31.07.22.
//

import SwiftUI

struct ShowConsciousnessView: View {
    @EnvironmentObject var consciousness: Consciousness

    var body: some View {
        ShowMemoryView(brain: consciousness.memory.brain)
        Button("Add") {
            _ = consciousness.memory.brain.createNeuron()
            consciousness.commit()
        }
    }
}

struct ShowMemoryView: View {
    @ObservedObject var brain: Brain

    var body: some View {
        List(brain.neurons) { neuron in
            Text("\(neuron.id.uuidString)")
        }
    }
}

 struct ShowConsciousnessView_Previews: PreviewProvider {
    static var previews: some View {
        ShowConsciousnessView()
            .environmentObject(Consciousness.preview1)
    }
 }

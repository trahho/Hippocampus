//
//  ShowAreaView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 31.07.22.
//

import SwiftUI

struct ShowAreaView: View {
    @EnvironmentObject var consciousness: Consciousness

    var area: Brain.Area {
        consciousness.area!
    }

    var brain: Brain {
        area.brain
    }

    var body: some View {
        List(brain.neurons) { neuron in
            Text("\(neuron.id.uuidString)")
        }
        Button("Add") {
            _ = brain.createNeuron()
        }
    }
}

struct ShowAreaView_Previews: PreviewProvider {
    static var previews: some View {
        ShowAreaView()
    }
}

//
//  ConditionEditView.ParticlePicker.swift
//  Hippocampus
//
//  Created by Guido Kühn on 13.07.24.
//

import Grisu
import SwiftUI

extension ConditionEditView {
    struct ParticlePicker: View {
        @Environment(\.structure) var structure
        @Binding var particle: Structure.Particle?
        @State var perspective: Structure.Perspective?

        var perspectives: [Structure.Perspective] {
            structure.perspectives
                .filter { !$0.particles.isEmpty }
                .sorted { $0.description < $1.description }
        }

        var body: some View {
            HStack {
                ValuePicker("Perspective", data: perspectives, selection: $perspective, unkown: "unknown")
                if let perspective, !perspective.particles.isEmpty {
                    ValuePicker("Particle", data: perspective.particles.sorted { $0.description < $1.description }, selection: $particle, unkown: "unknown")
                } else {
                    Spacer()
                }
            }
        }
    }
}

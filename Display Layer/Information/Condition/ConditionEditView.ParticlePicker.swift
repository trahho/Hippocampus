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
        @State var role: Structure.Role?

        var roles: [Structure.Role] {
            structure.roles
                .filter { !$0.particles.isEmpty }
                .sorted { $0.description < $1.description }
        }

        var body: some View {
            HStack {
                ValuePicker("Role", data: roles, selection: $role, unkown: "unknown")
                if let role, !role.particles.isEmpty {
                    ValuePicker("Particle", data: role.particles.sorted { $0.description < $1.description }, selection: $particle, unkown: "unknown")
                } else {
                    Spacer()
                }
            }
        }
    }
}

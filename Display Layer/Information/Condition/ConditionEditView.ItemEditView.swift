//
//  ConditionEditView.ItemEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.07.24.
//

import Grisu
import SwiftUI

extension ConditionEditView {
    struct ItemEditView: View {
        // MARK: Properties

        @Environment(\.document) var document
        @Environment(\.structure) var structure
        @Binding var condition: Information.Condition
        @Binding var array: [Information.Condition]

        // MARK: Computed Properties

        var draggable: Information.Condition {
            array.remove(item: condition)
            return condition
        }

        var roles: [Structure.Role] {
            structure.roles.sorted { $0.description < $1.description }
        }

        var sourceCode: String {
            condition.sourceCode(tab: 0, inline: true, document: document)
        }

        // MARK: Content

        var contextMenu: some View {
            ContextMenu(condition: $condition, array: $array)
        }

        var body: some View {
            Group {
                switch condition {
                case .nil:
                    Label("Nil", systemImage: "circle.slash")
                        .contextMenu { contextMenu }
                case let .always(bool):
                    HStack {
                        Label("Always", systemImage: "circle.righthalf.filled")
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                        Toggle("\(bool)", isOn: Binding(get: { bool }, set: { condition = .always($0) }))
                            .toggleStyle(.button)
                    }
                case let .role(roleId):
                    HStack {
                        Label("Has Role (\(role(id: roleId)?.name ?? "unknown"))", systemImage: "theatermasks")
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                        ValuePicker("", data: roles, selection: Binding<Structure.Role?>(get: { role(id: roleId) }, set: { role in
                            guard let role else { return }
                            condition = .role(role.id)
                        }), unkown: "unknown")
                        .sensitive
                    }
                case let .hasParticle(particleId, child):
                    VStack(alignment: .leading) {
                        Label("Has Role (\(particle(id: particleId)?.name ?? "unknown"))", systemImage: "circle.hexagongrid.circle")
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                        ParticlePicker(particle: Binding<Structure.Particle?>(get: { particle(id: particleId) }, set: { particle in
                            guard let particle else { return }
                            condition = .hasParticle(particle.id, child)
                        }), role: particle(id: particleId)?.role)
                        Text("Condition")
                            .dropDestination { items, _ in condition = .hasParticle(particleId, items.first! && child); return true }
                        ArrayEditView(array: Binding(get: { [child] }, set: { condition = .hasParticle(particleId, $0.first ?? .nil) }))
                    }
                case let .isParticle(particleId):
                    VStack(alignment: .leading) {
                        Label("Is Particle (\(particle(id: particleId)?.name ?? "unknown"))", systemImage: "circle.hexagongrid")
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                        ParticlePicker(particle: Binding<Structure.Particle?>(get: { particle(id: particleId) }, set: { particle in
                            guard let particle else { return }
                            condition = .isParticle(particle.id)
                        }), role: particle(id: particleId)?.role)
                    }
                case let .isReferenced(child):
                    VStack(alignment: .leading) {
                        Label("Is Referenced by", systemImage: "arrowshape.turn.up.left.circle")
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                        ArrayEditView(array: Binding(get: { [child] }, set: { condition = .isReferenced($0.first ?? .nil) }))
                    }
                case let .hasReference(child):
                    VStack(alignment: .leading) {
                        Label("Has Reference to", systemImage: "arrowshape.turn.up.right.circle")
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                        ArrayEditView(array: Binding(get: { [child] }, set: { condition = .hasReference($0.first ?? .nil) }))
                    }
                case let .isReferenceOfRole(roleId):
                    VStack(alignment: .leading) {
                        Label("Is Reference of Role (\(role(id: roleId)?.name ?? "unknown"))", systemImage: "theatermasks.circle")
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                        ValuePicker("", data: roles.filter { !$0.references.isEmpty }, selection: Binding<Structure.Role?>(get: { role(id: roleId) }, set: { role in
                            guard let role else { return }
                            condition = .isReferenceOfRole(role.id)
                        }), unkown: "unknown")
                    }
                //            case .hasValue(let comparison):
                //                <#code#>
                case let .not(child):
                    VStack(alignment: .leading) {
                        Label("Not", systemImage: "exclamationmark")
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                        ArrayEditView(array: Binding(get: { [child] }, set: { condition = .not($0.first ?? .nil) }))
                    }
                case let .any(children):
                    VStack(alignment: .leading) {
                        Label("Any matching", systemImage: "text.line.first.and.arrowtriangle.forward")
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                            .dropDestination { items, _ in condition = .any(items + children); return true }
                        ArrayEditView(array: Binding(get: { children }, set: { condition = .any($0) }))
                    }
                case let .all(children):
                    VStack(alignment: .leading) {
                        Label("All matching", systemImage: "text.line.last.and.arrowtriangle.forward")
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                            .dropDestination { items, _ in condition = .all(items + children); return true }
                        ArrayEditView(array: Binding(get: { children }, set: { condition = .all($0) }))
                    }
                default:
                    EmptyView()
                }
            }
            .padding(6)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.primary, lineWidth: 1)
            }
        }

        // MARK: Functions

        func role(id: Structure.Role.ID) -> Structure.Role? {
            guard let role = structure[Structure.Role.self, id] else { return nil }
            return role
        }

        func particle(id: Structure.Particle.ID) -> Structure.Particle? {
            guard let particle = structure[Structure.Particle.self, id] else { return nil }
            return particle
        }
    }
}

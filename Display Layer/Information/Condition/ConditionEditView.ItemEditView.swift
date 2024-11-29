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

        var perspectives: [Structure.Perspective] {
            structure.perspectives.sorted { $0.description < $1.description }
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
                case let .perspective(perspectiveId):
                    HStack {
                        Label("Has Perspective (\(perspective(id: perspectiveId)?.name ?? "unknown"))", systemImage: "theatermasks")
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                        ValuePicker("", data: perspectives, selection: Binding<Structure.Perspective?>(get: { perspective(id: perspectiveId) }, set: { perspective in
                            guard let perspective else { return }
                            condition = .perspective(perspective.id)
                        }), unkown: "unknown")
                            .sensitive
                    }
                case let .hasParticle(particleId, child):
                    VStack(alignment: .leading) {
                        Label("Has Perspective (\(particle(id: particleId)?.name ?? "unknown"))", systemImage: "circle.hexagongrid.circle")
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                        ParticlePicker(particle: Binding<Structure.Particle?>(get: { particle(id: particleId) }, set: { particle in
                            guard let particle else { return }
                            condition = .hasParticle(particle.id, child)
                        }), perspective: particle(id: particleId)?.perspective)
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
                        }), perspective: particle(id: particleId)?.perspective)
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
                case let .isReferenceOfPerspective(perspectiveId):
                    VStack(alignment: .leading) {
                        Label("Is Reference of Perspective (\(perspective(id: perspectiveId)?.name ?? "unknown"))", systemImage: "theatermasks.circle")
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                        ValuePicker("", data: perspectives.filter { !$0.references.isEmpty }, selection: Binding<Structure.Perspective?>(get: { perspective(id: perspectiveId) }, set: { perspective in
                            guard let perspective else { return }
                            condition = .isReferenceOfPerspective(perspective.id)
                        }), unkown: "unknown")
                    }
                case let .hasValue(comparison):
                    VStack(alignment: .leading) {
                        Label("Has value", systemImage: "number.circle")
                            .contextMenu { contextMenu }
                            .draggable(draggable)
                        ComparisonEditView(comparison: Binding(get: { comparison }, set: { condition = .hasValue($0) }))
                    }
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
                }
            }
            .padding(6)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.primary, lineWidth: 1)
            }
        }

        // MARK: Functions

        func perspective(id: Structure.Perspective.ID) -> Structure.Perspective? {
            structure[Structure.Perspective.self, id]
        }

        func aspect(id: Structure.Aspect.ID) -> Structure.Aspect? {
            structure[Structure.Aspect.self, id]
        }

        func particle(id: Structure.Particle.ID) -> Structure.Particle? {
            guard let particle = structure[Structure.Particle.self, id] else { return nil }
            return particle
        }
    }

    struct ComparisonEditView: View {
        // MARK: Properties

        @Environment(\.document) var document
        @Binding var comparison: Information.Condition.Comparison

        // MARK: Content

        var body: some View {
            Group {
                switch comparison {
                case let .equal(aspectId, value, form):
                    VStack(alignment: .leading) {
                        Label("Is equal ", systemImage: "equal.square")
                        //                        .contextMenu { contextMenu }
                        AspectSelector(schräg: Binding(get: { (aspect: aspectId, form: form) }, set: { comparison = .equal($0.aspect, value, $0.form) }))
//                        if let aspect = document[Structure.Aspect.self, aspectId] {
//                            AspectValueView(aspect: aspect, value: Binding(get: { value }, set: { comparison = .equal(aspectId, form, .constant($0) }), appearance: .edit)
//                        } else {
//                            Text("No aspect found.")
//                        }
                    }
                case let .below(aspectId, form, value):
                    VStack(alignment: .leading) {
                        Label("Is below ", systemImage: "equal.square")
                        //                        .contextMenu { contextMenu }
//                        AspectSelector(schräg: Binding(get: { (aspect: aspectId, form: form) }, set: { comparison = .below($0.aspect, $0.form, value) }))
                    }
                case let .above(aspectId, form, value):
                    VStack(alignment: .leading) {
                        Label("Is above ", systemImage: "equal.square")
                        //                        .contextMenu { contextMenu }
//                        AspectSelector(schräg: Binding(get: { (aspect: aspectId, form: form) }, set: { comparison = .above($0.aspect, $0.form, value) }))
                    }
                case let .unequal(aspectId, form, value):
                    VStack(alignment: .leading) {
                        Label("Is unequal ", systemImage: "equal.square")
                        //                        .contextMenu { contextMenu }
//                        AspectSelector(schräg: Binding(get: { (aspect: aspectId, form: form) }, set: { comparison = .unequal($0.aspect, $0.form, value) }))
                    }
                case let .anyValue(aspectId):
                    VStack(alignment: .leading) {
                        Label("Has any valuel ", systemImage: "equal.square")
                        //                        .contextMenu { contextMenu }
//                        AspectSelector(aspectId: Binding(get: { aspectId }, set: { comparison = .anyValue($0) }))
                    }
                case .nil:
                    Label("Nothing", systemImage: "equal.square")
                }
            }
            .padding(6)
        }
    }
}

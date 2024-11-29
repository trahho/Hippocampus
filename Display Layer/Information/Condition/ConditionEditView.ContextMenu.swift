//
//  ConditionEditView.ContextMenu.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.07.24.
//

import SwiftUI

extension ConditionEditView {
    struct ContextMenu: View {
        // MARK: Properties

        @Binding var condition: Information.Condition
        @Binding var array: [Information.Condition]

        // MARK: Computed Properties

        var children: [Information.Condition] {
            switch condition {
            case let .all(children), let .any(children):
                children
            case let .hasParticle(_, child):
                [child]
            case let .hasReference(child):
                [child]
            case let .isReferenced(child):
                [child]
            case let .not(child):
                [child]
            default:
                []
            }
        }

        // MARK: Content

        var body: some View {
            Button {
                remove()
            } label: {
                Label("Remove", systemImage: "trash")
            }

            switch condition {
            case .all, .any:
                Menu("Add") {
                    Button("Not") { add(item: .not(.nil)) }
                    Button("Always") { add(item: .always(true)) }
                    Button("Perspective") { add(item: .perspective(.nil)) }
                    Button("Is Particle") { add(item: .isParticle(.nil)) }
                    Button("Has Particle") { add(item: .hasParticle(.nil, .nil)) }
                    Button("Has Reference") { add(item: .hasReference(.nil)) }
                    Button("Is Referenced by") { add(item: .isReferenced(.nil)) }
                    Button("Is Reference of Perspective") { add(item: .isReferenceOfPerspective(.nil)) }
                    Button("Has Value") { add(item: .hasValue(.nil)) }
                }
                Menu("Change to") {
                    if case let .all(children) = condition {
                        Button("Some") { condition = .any(children) }
                    }
                    if case let .any(children) = condition {
                        Button("All") { condition = .all(children) }
                    }
                }
            default:
                Menu("Change to") {
                    Button("Nil") { condition = .nil }
                    Button("Not") { condition = .not(.nil) }
                    Button("Always") { condition = .always(true) }
                    Button("Perspective") { condition = .perspective(.nil) }
                    Button("Is Particle") { condition = .isParticle(.nil) }
                    Button("Has Particle") { condition = .hasParticle(.nil, .nil) }
                    Button("Has Reference") { condition = .hasReference(.nil) }
                    Button("Is Referenced by") { condition = .isReferenced(.nil) }
                    Button("Is Reference of Perspective") { condition = .isReferenceOfPerspective(.nil) }
                    Button("Has Value") { condition = .hasValue(.nil) }
                }
            }
            Menu("Wrap in") {
                Button("Not") { condition = .not(condition) }
                Button("All") { condition = .all([condition]) }
                Button("Any") { condition = .any([condition]) }
                Button("For Particle") { condition = .hasParticle(.nil, condition) }
                Button("Has Reference") { condition = .hasReference(condition) }
                Button("Is Referenced by") { condition = .isReferenced(condition) }
            }
        }

        // MARK: Functions

        func add(item: Information.Condition) {
            switch condition {
            case let .all(children):
                condition = .all(children + [item])
            case let .any(children):
                condition = .all(children + [item])
            default:
                break
            }
        }

        func remove() {
            guard let index = array.firstIndex(of: condition) else { return }
            switch condition {
            case let .all(children), let .any(children):
                guard !children.isEmpty else { return }
                array[index] = children.first!
            default:
                array.remove(at: index)
            }
        }
    }
}

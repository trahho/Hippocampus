//
//  ConditionEditView.ContextMenu.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.07.24.
//

import SwiftUI

extension ConditionEditView {
    struct ContextMenu: View {
        @Binding var condition: Information.Condition
        @Binding var array: [Information.Condition]
        
        var children: [Information.Condition] {
            switch condition {
            case .all(let children), .any(let children):
                children
            case .hasParticle(_, let child):
                [child]
            case .hasReference(let child):
                [child]
            case .isReferenced(let child):
                [child]
            case .not(let child):
                [child]
            default:
                []
            }
        }
        
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
                    Button("Role") { add(item: .role(.nil)) }
                    Button("Is Particle") { add(item: .isParticle(.nil)) }
                    Button("Has Particle") { add(item: .hasParticle(.nil, .nil)) }
                    Button("Has Reference") { add(item: .hasReference(.nil)) }
                    Button("Is Referenced by") { add(item: .isReferenced(.nil)) }
                    Button("Is Reference of Role") { add(item: .isReferenceOfRole(.nil)) }
                    Button("Has Value") { add(item: .hasValue(.nil)) }
                }
                Menu("Change to") {
                    if case .all(let children) = condition {
                        Button("Some") { condition = .any(children) }
                    }
                    if case .any(let children) = condition {
                        Button("All") { condition = .all(children) }
                    }
                }
            default:
                Menu("Change to") {
                    Button("Not") { condition = .not(.nil) }
                    Button("Always") { condition = .always(true) }
                    Button("Role") { condition = .role(.nil) }
                    Button("Is Particle") { condition = .isParticle(.nil) }
                    Button("Has Particle") { condition = .hasParticle(.nil, .nil) }
                    Button("Has Reference") { condition = .hasReference(.nil) }
                    Button("Is Referenced by") { condition = .isReferenced(.nil) }
                    Button("Is Reference of Role") { condition = .isReferenceOfRole(.nil) }
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
        
        func add(item: Information.Condition) {
            switch condition {
            case .all(let children):
                condition = .all(children + [item])
            case .any(let children):
                condition = .all(children + [item])
            default:
                break
            }
        }
        
        func remove() {
            guard let index = array.firstIndex(of: condition) else { return }
            switch condition {
            case .all(let children), .any(let children):
                guard !children.isEmpty else { return }
                array[index] = children.first!
            default:
                array.remove(at: index)
            }
        }
    }
}

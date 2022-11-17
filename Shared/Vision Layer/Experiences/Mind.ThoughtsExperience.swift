//
//  Mind.ThoughtsExperience.swift
//  Hippocampus
//
//  Created by Guido Kühn on 06.11.22.
//

import Foundation
import SwiftUI

extension Mind {
    func experienceThoughts(selected: Binding<Thought?>) -> some View {
        ThoughtsExperience(selected: selected)
            .environmentObject(self)
    }

    struct ThoughtsExperience: View {
        @EnvironmentObject var mind: Mind
        @Binding var selected: Thought?

        var thoughts: [Mind.Thought] {
            mind.thoughts.values.sorted(using: KeyPathComparator(\.designation, order: .forward))
        }

        var body: some View {
            List(thoughts) { thought in
//                ForEach(thoughts) { thought in
                HStack {
//                    Image(systemName: thought == selected ? "" : "")
                    Text(thought.designation)
                        .foregroundColor(thought == selected ? Color.accentColor : Color.primary)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selected = thought
                        }
                    //                }
                }
            }
        }
    }
}

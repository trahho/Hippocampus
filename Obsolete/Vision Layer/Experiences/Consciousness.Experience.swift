////
////  Consciousness.Experience.swift
////  Hippocampus
////
////  Created by Guido Kühn on 06.11.22.
////
//
// import Foundation
// import SwiftUI
//
// extension Consciousness {
//    func experience() -> some View {
//        Experience()
//            .environmentObject(self)
//            .environmentObject(self.memory.brain)
//            .environmentObject(self.memory.mind)
//            .environmentObject(self.memory.imagination)
//    }
//
//    struct Experience: View {
//        @EnvironmentObject var consciousness: Consciousness
//        @EnvironmentObject var mind: Mind
//        @EnvironmentObject var imagination: Imagination
//
//        var thoughts: [Mind.Thought] {
//            self.mind.thoughts.sorted(using: KeyPathComparator(\.designation, order: .forward))
//        }
//
//        var body: some View {
////           NavigationSplitView {
////
////           }
////           TabView {
//            NavigationSplitView {
//                List(thoughts, selection: $consciousness.currentThought) { thought in
//                    Text(thought.designation)
//                }
//            } content: {
//                if let selected = consciousness.currentThought {
////                    imagination.experiencePossibleExperiences(for: selected)
//                    let experiences = imagination.experiences[selected.id] ?? [
//                        Imagination.Experience("Wat auch immer", .list)
//                    ]
//                    List(experiences, selection: $consciousness.currentExperience) { experience in
//                        Text(experience.designation)
//                    }
//                } else {
//                    Image(systemName: "questionmark.key.filled")
//                }
//            }
//            detail: {
//                Image(systemName: "bubbles.and.sparkles")
//            }
////                   .tabItem {
////                       Label("Thoughts", systemImage: "bubbles.and.sparkles")
////                   }
////                Text("Ideen")
////                    .tabItem {
////                        Label("Ideas", systemImage: "lightbulb")
////                    }
////                Text("Favoriten")
////                    .tabItem {
////                        Label("Favourites", systemImage: "heart")
////                    }
//        }
//    }
// }

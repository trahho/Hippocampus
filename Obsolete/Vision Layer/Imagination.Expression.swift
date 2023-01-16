//
//  Expression.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.10.22.
//

import Foundation
import SwiftUI

extension Imagination {
    struct Expression: View {
        @ObservedObject var brain: Brain
        @ObservedObject var thought: Mind.Thought
        @ObservedObject var experience: Experience

        var body: some View {
            Group {
                switch experience.impression {
                case .list:
                    ListExpression(experience: experience)
                default:
                    EmptyView()
                }
            }.environmentObject(experience.genes)
//                .onAppear {
//                    thought.rethink(of: brain)
//                }
        }

        struct ListExpression: View {
            @ObservedObject var experience: Experience
            @State var layouter: Experience

            init(experience: Experience) {
                self.experience = experience
                layouter = experience
            }

            var body: some View {
                EmptyView()
//                List(experience.rootItems) {}
            }
        }
    }
}

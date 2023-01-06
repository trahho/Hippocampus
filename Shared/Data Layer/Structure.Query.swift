//
//  Structure.Query.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation

extension Structure {
    class Query: Object {
        static let notes = Query("89913172-022C-4EF0-95BA-76FF8E32F18B", "Notizen") {
            Predicate([.note, .topic], .hasRole(role: Role.note.id))
//            Predicate([.note, .topic], .hasRole(Role.note.id) || .hasRole(Role.topic.id))
        }

        @Persistent var name: String
        @Persistent var predicates: [Predicate]

        func apply(to information: Information) -> Result {
            let result = Result()
            for node in information.nodes {
                analyze(node: node, in: information, for: result)
            }
            return result
        }

        func analyze(_ item: Information.Item) -> Set<Role>? {
            var result = Set<Role>()
            var matches = false

            for predicate in predicates {
                if predicate.matches(for: item) {
                    matches = true
                    result.formUnion(predicate.roles)
                }
            }

            return matches ? result : nil
        }

        func analyze(_ item: Query.Result.Item) -> Set<Role>? {
            analyze(item.item)
        }

        func analyze(node: Information.Node, in information: Information, for result: Result) {
            guard result.nodeStorage[node.id] == nil else { return }
            let roles = analyze(node)
            if let roles {
                let item = Result.Node(node: node, roles: roles)
                result.nodeStorage[node.id] = item
                for edge in node.outgoing {
                    analyze(edge: edge, in: information, for: result)
                }
            }
        }

        func analyze(edge: Information.Edge, in information: Information, for result: Result) {
            guard result.edgeStorage[edge.id] == nil else { return }
            analyze(node: edge.to, in: information, for: result)
            guard let from = result.nodeStorage[edge.from.id], let to = result.nodeStorage[edge.to.id] else { return }
            let roles = analyze(edge)
            let item = Result.Edge(edge: edge, roles: roles ?? [], from: from, to: to)
            result.edgeStorage[edge.id] = item
        }
    }
}

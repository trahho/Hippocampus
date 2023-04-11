//
//  Structure.Query.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation

extension Structure {
    class Query: Object {
        typealias RoleRepresentation = Presentation.RoleRepresentation
        fileprivate enum Keys {
            static let notes = "89913172-022C-4EF0-95BA-76FF8E32F18B"
            static let topics = "B7430903-0AC5-4C72-91E5-B54B73C8B5FD"
        }

        static let roleRepresentations: [RoleRepresentation] = [RoleRepresentation(.global, "_Title")]

        static let notes = Query(Keys.notes, "_Notes") {
//            Predicate([.note, .topic], .hasRole(Role.note.id))
            Predicate([.note], .hasRole(Role.note.id))
        } representations: {
            RoleRepresentation(.topic, "_Title")
            RoleRepresentation(.drawing, "_Icon")
            RoleRepresentation(.drawing, "_Card")
            RoleRepresentation(.text, "_Introduction_Short")
        }

        static let topics = Query(Keys.topics, "_Topics") {
//            Predicate([.note, .topic], .hasRole(Role.note.id))
            Predicate([.topic], .hasRole(Role.topic.id))
        }

        @Persistent var name: String
        @PublishedSerialized var predicates: [Predicate]
        @PublishedSerialized var roleRepresentations: [RoleRepresentation] = []
        @PublishedSerialized var layout: Presentation.Layout = .tree
        @Serialized var isStatic = false

        func getRepresentation(_: any Sequence<RoleRepresentation>, for role: Structure.Role) -> String? {
            let specific = roleRepresentations
                .filter { $0.roleId == role.id } // && $0.layouts.contains(layout) }
                .map(\.representation)
                .first
            let general = roleRepresentations
                .filter { $0.roleId == role.id } // && $0.layouts.isEmpty }
                .map(\.representation)
                .first
            return specific ?? general
        }

        static let defaultRepresentation = Structure.Representation.aspect(Structure.Role.global.name, form: .normal)

        func roleRepresentation(role: Structure.Role, layout _: Presentation.Layout) -> String? {
            getRepresentation(roleRepresentations, for: role) ?? getRepresentation(Self.roleRepresentations, for: role)
        }

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

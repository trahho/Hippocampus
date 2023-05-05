//
//  Structure.Query.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation
import Smaug

extension Presentation {
    struct ItemDetail: Hashable {
        let id = UUID()
        let item: Information.Item
        let roles: [Structure.Role]

        var name: String {
            item[String.self, Structure.Role.global.name] ?? ""
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    class Query: Object {
        @Property var name: String
        @References(\Group.queries) var groups: Set<Group>

        var isTop: Bool { groups.isEmpty }

        @Relations var predicates: Set<Predicate>
        @Relations var roleRepresentations: Set<RoleRepresentation>
        @PublishedSerialized var layout: Presentation.Layout = .tree
        @Serialized var isStatic = false
        @Published var items: [ItemDetail] = []

        func getRepresentation(_: any Sequence<RoleRepresentation>, for role: Structure.Role) -> RoleRepresentation?
        {
            let specific = roleRepresentations
                .filter { $0.role == role } // && $0.layouts.contains(layout) }
                .first
            let general = roleRepresentations
                .filter { $0.role == role } // && $0.layouts.isEmpty }
                .first
            return specific ?? general
        }

        static let defaultRepresentation = Structure.Presentation.aspect(Structure.Role.global.name, form: Form.normal)

        func roleRepresentation(role: Structure.Role, layout _: Presentation.Layout) -> RoleRepresentation? {
            getRepresentation(roleRepresentations, for: role) ?? getRepresentation(Self.roleRepresentations, for: role)
        }

        func apply(to information: Information) -> Result {
            let result = Result()
            for node in information.nodes {
                analyze(node: node, in: information, for: result)
            }
            return result
        }

        func analyze(_ item: Information.Item) -> Set<Structure.Role>? {
            var result = Set<Structure.Role>()
            var matches = false

            for predicate in predicates {
                if predicate.matches(for: item) {
                    matches = true
                    result.formUnion(predicate.roles)
                }
            }

            return matches ? result : nil
        }

        func analyze(_ item: Query.Result.Item) -> Set<Structure.Role>? {
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

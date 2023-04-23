//
//  Structure.Query.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation

extension Presentation {
    struct ItemDetail: Hashable {
        let id = UUID()
        let Item: Information.Item
        let Roles: [Structure.Role]
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    class Query: Object {
        typealias Role = Structure.Role
        typealias Form = Structure.Aspect.Presentation.Form

        //        typealias Predicate = Presentation.Predicate
        fileprivate enum Keys {
            static let general = "2D7A4847-BE08-4987-8D19-039B3E3484A8"
            static let notes = "89913172-022C-4EF0-95BA-76FF8E32F18B"
            static let topics = "B7430903-0AC5-4C72-91E5-B54B73C8B5FD"
        }

        static let roleRepresentations: [RoleRepresentation] = [RoleRepresentation(.global, "_Title")]

        static let general = Query(Keys.general, "_General") {
            Predicate([.global], .always(true))
        }

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

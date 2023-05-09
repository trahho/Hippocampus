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
        @Relations(\Group.queries) var groups: Set<Group>

        var isTop: Bool { groups.isEmpty }

        @Objects var predicates: Set<Predicate>
        @Objects var roleRepresentations: Set<RoleRepresentation>
        @PublishedSerialized var layout: Presentation.Layout = .tree
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

        func apply(to information: Information) -> PresentationResult.Result {
            let result = PresentationResult.Result()
            add(result)
            for item in information.items {
                analyze(item: item, in: information, for: result)
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

        func analyze(_ item: PresentationResult.Item) -> Set<Structure.Role>? {
            analyze(item.item)
        }

        func analyze(item: Information.Item, in information: Information, for result: PresentationResult.Result) {
            guard !result.items.contains(where: { $0.item == item }) else { return }
            print ("Analyze \(item[String.self, Structure.Role.global.name] ?? "Nix")")
            let roles = analyze(item)
            if let roles {
                let resultItem = PresentationResult.Item(item: item, roles: roles)
                result.items.insert(resultItem)

                item.to.forEach { item in
                    analyze(item: item, in: information, for: result)
                }
            }
        }

//        func analyze(edge: Information.Item, in information: Information, for result: PresentationResult.Result) {
        ////            guard result.edgeStorage[edge.id] == nil else { return }
        ////            analyze(node: edge.to.first!, in: information, for: result)
        ////            guard let from = result.nodeStorage[edge.from.id], let to = result.nodeStorage[edge.to.id] else { return }
        ////            let roles = analyze(edge)
        ////            let item = Result.Edge(edge: edge, roles: roles ?? [], from: from, to: to)
        ////            result.edgeStorage[edge.id] = item
//        }
    }
}

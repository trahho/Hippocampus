//
//  Structure.Query.Result.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation

extension Set<Structure.Role> {
    func contains(_ memberId: Structure.Role.ID) -> Bool {
        contains { role in
            role.id == memberId
        }
    }
}

extension Presentation.Query {
    class Result {
        class Item: IdentifiableObject, ObservableObject {
            @Observed var item: Information.Item
            var roles: Set<Structure.Role>

            override var id: Information.Item.ID {
                get { item.id }
                set {}
            }

            init(item: Information.Item, roles: Set<Structure.Role>) {
                self.roles = roles.filter { item[role: $0] == true }
                super.init()
                self.item = item
            }
        }

        class Node: Item {
            var from: Set<Edge> = []
            var to: Set<Edge> = []

            init(node: Information.Node, roles: Set<Structure.Role>) {
                super.init(item: node, roles: roles)
            }
        }

        class Edge: Item {
            var from: Node
            var to: Node

            init(edge: Information.Edge, roles: Set<Structure.Role>, from: Node, to: Node) {
                self.from = from
                self.to = to
                super.init(item: edge, roles: roles)
                from.to.insert(self)
                to.from.insert(self)
            }
        }

        var nodeStorage: [Information.Node.ID: Node] = [:]
        var edgeStorage: [Information.Edge.ID: Edge] = [:]

        var nodes: Set<Node> {
            Set(nodeStorage.values)
        }

        var edges: Set<Edge> {
            Set(edgeStorage.values)
        }
    }
}

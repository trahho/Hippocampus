//
//  Structure.Query.Result.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import Smaug

// extension Set<Structure.Role> {
//    func contains(_ memberId: Structure.Role.ID) -> Bool {
//        contains { role in
//            role.id == memberId
//        }
//    }
// }

extension Presentation {
    class Item: Presentation.Object {
        @Observed var item: Information.Item
        @Objects var roles: Set<Structure.Role>
        @Objects var next: Set<Item>

        init(item: Information.Item, roles: Set<Structure.Role>) {
            super.init()
            self.roles = roles.intersection(item.roles)
            self.item = item
            self.id = item.id
        }

        required init() {}
    }

    class Node: Item {
//            var from: Set<Edge> = []
//            var to: Set<Edge> = []
//
//            required init() {super.init()}
//
//            init(node: Information.Item, roles: Set<Structure.Role>) {
//                super.init(item: node, roles: roles)
//            }
    }

    class Edge: Item {
//            var from: Node
//            var to: Node
//
//            required init() {.init()}
//
//            init(edge: Information.Item, roles: Set<Structure.Role>, from: Node, to: Node) {
//                self.from = from
//                self.to = to
//                super.init(item: edge, roles: roles)
//                from.to.insert(self)
//                to.from.insert(self)
//            }
    }

    class Result {
//        class Item: IdentifiableObject, ObservableObject {

        var nodeStorage: [Information.Item.ID: Node] = [:]
        var edgeStorage: [Information.Item.ID: Edge] = [:]

        var nodes: Set<Node> {
            Set(nodeStorage.values)
        }

        var edges: Set<Edge> {
            Set(edgeStorage.values)
        }
    }
}

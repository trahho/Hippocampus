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

extension PresentationResult {
    class Item: Object {
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
        @Relations(\Edge.to) var from: Set<Edge>
        @Relations(\Edge.to) var to: Set<Edge>

        required init() { super.init() }

        init(node: Information.Item, roles: Set<Structure.Role>) {
            super.init(item: node, roles: roles)
        }
    }

    class Edge: Item {
        @Object var from: Node!
        @Object var to: Node!
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

    class Result: Object {
//        class Item: IdentifiableObject, ObservableObject {

        @Objects var nodes: Set<Node>
        @Objects var edges: Set<Edge>
    }
}

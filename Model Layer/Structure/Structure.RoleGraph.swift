//
//  Structure.RoleGraph.swift
//  Hippocampus
//
//  Created by Guido Kühn on 13.05.23.
//

import Foundation
import SwiftUI

extension Structure {
    class Node: RoleGraph.GraphNode {
        var role: Role?

        override var body: AnyView {
            AnyView(myBody)
        }

        @ViewBuilder
        var myBody: some View {
            if let role { Text(role.roleDescription) }
            else { super.body }
        }

        init(role: Role?) {
            self.role = role
            super.init()
        }
    }

    class Edge: RoleGraph.Edge {}
}

extension Structure {
    class RoleGraph: Graph {
        func getNode(role: Role) -> Node {
            if let node = nodes.compactMap({ $0 as? Node }).first(where: { $0.role == role }) { return node }

            let node = Node(role: role)
            nodes.append(node)
            return node
        }

        func build(for role: Role) {
            let node = getNode(role: role)
            node.alignment = .center
            for sub in role.subRoles {
                let subNode = getNode(role: sub)
                subNode.alignment = .top
                let edge = Edge(from: node, to: subNode)
                nodes.append(edge)
            }
        }

        init(role: Role) {
            super.init()
            self.layouter = ComplexSpringLayouter()
            build(for: role)
        }
    }
}

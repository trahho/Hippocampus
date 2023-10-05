//
//  Structure.RoleGraph.swift
//  Hippocampus
//
//  Created by Guido Kühn on 13.05.23.
//

import Foundation
import SwiftUI

extension Structure {
    class RoleNode: RoleGraph.Node {
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

    class RoleEdge: RoleGraph.Edge {}
}

extension Structure {
    class RoleGraph: Graph {
        func getNode(role: Role) -> Node {
            if let node = nodes.compactMap({ $0 as? RoleNode }).first(where: { $0.role == role }) { return node }

            let node = RoleNode(role: role)
            nodes.append(node)
            return node
        }

        func build(for role: Role) {
            let node = getNode(role: role)
//            node.alignment = .center
//            let subroles = role.subRoles.sorted { $0.roleDescription < $1.roleDescription }
            var lastEdge: Edge? = nil
            for sub in role.subRoles {
                let subNode = getNode(role: sub)
//                subNode.alignment = .top
                let edge = RoleEdge(from: node, to: subNode)
                edge.alignment = .topLeading
                edge.sortBefore = lastEdge
                nodes.append(edge)
                lastEdge = edge
            }
        }

        init(role: Role) {
            super.init()
            self.layouter = ComplexSpringLayouter()
            build(for: role)
        }
    }
}

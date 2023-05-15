//
//  Structure.Query.Result.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import Smaug
import SwiftUI

extension Presentation.PresentationResult {
    class Result: Object {
        @Object var query: Presentation.Query!
        @Objects var items: Set<Item>
    }
}

extension Presentation.PresentationResult {
    class Node: Graph.GraphNode {
        var item: Item?

        init(item: Item?) {
            self.item = item
            super.init()
        }
    }

    class Edge: Graph.Edge {
        convenience init(item: Presentation.PresentationResult.Item? = nil, from: Node, to: Node) {
            self.init(from: from, to: to)
        }
    }
}

extension Presentation.PresentationResult {
    class PresentationGraph: Graph {
        func getNode(item: Item) -> Node {
            if let node = nodes.compactMap({ $0 as? Node }).first(where: { $0.item == item }) { return node }

            let node = Node(item: item)
            nodes.append(node)
            return node
        }

        func build(for items: Set<Presentation.PresentationResult.Item>) {
            for item in items {
                let node = getNode(item: item)
                for next in item.next {
                    let nextNode = getNode(item: next)
                    nodes.append(Edge(from: node, to: nextNode))
                }
            }
        }

        init(result: Result) {
            super.init()
            build(for: result.items)
        }
    }
}

////
////  Structure.Query.Result.swift
////  Hippocampus
////
////  Created by Guido Kühn on 27.12.22.
////
//
//import Foundation
//import Smaug
//import SwiftUI
//
//extension Presentation.PresentationResult {
//    class Result: Object {
//        @Object var query: Presentation.Query!
//        @Objects var items: Set<Item>
//    }
//}
//
//extension Presentation.PresentationResult {
//    class PresentationNode: Graph.Node {
//        var query: Presentation.Query!
//        var item: Item?
//
//        @ViewBuilder
//        var representation: some View {
//            if let item {
//                let representation = item.roles.compactMap {
//                    if let representation = query.roleRepresentation(role: $0, layout: .list) {
//                        return representation.role.representation(for: representation.representation)
//                    }
//                    return nil
//                }.first ?? Presentation.Query.defaultRepresentation
//                
//                representation.view(for: item.item)
//            } else {
//                EmptyView()
//            }
//        }
//
//        override var body: AnyView {
//            AnyView(representation)
//        }
//
//        init(item: Item?) {
//            self.item = item
//            super.init()
//        }
//    }
//
//    class PresentationEdge: Graph.Edge {
//        convenience init(item: Presentation.PresentationResult.Item? = nil, from: PresentationNode, to: PresentationNode) {
//            self.init(from: from, to: to)
//        }
//    }
//}
//
//extension Presentation.PresentationResult {
//    class PresentationGraph: Graph {
//        func getNode(item: Item) -> PresentationNode {
//            if let node = nodes.compactMap({ $0 as? PresentationNode }).first(where: { $0.item == item }) { return node }
//
//            let node = PresentationNode(item: item)
//            nodes.append(node)
//            return node
//        }
//
//        func build(_ query: Presentation.Query, for items: Set<Presentation.PresentationResult.Item>) {
//            for item in items {
//                let node = getNode(item: item)
//                node.query = query
//                for next in item.next {
//                    let nextNode = getNode(item: next)
//                    node.query = query
//                    nodes.append(PresentationEdge(from: node, to: nextNode))
//                }
//            }
//        }
//
//        init(query: Presentation.Query, result: Result) {
//            super.init()
//            layouter = MySpringLayouter()
//            build(query, for: result.items)
//        }
//    }
//}

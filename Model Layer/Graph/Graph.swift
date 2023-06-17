//
//  Graph.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.05.23.
//

import Foundation
import Smaug
import SwiftUI

protocol GraphLayouter {
    var equilibrium: Bool { get }
    func layout(graph: Graph)
}

class Graph: IdentifiableObject, ObservableObject {
    @Published var nodes: [Node] = []
    var edges: [Edge] {
        nodes.compactMap { $0 as? Edge }
    }

    var layouter: GraphLayouter?
    @Published var isLayouting = false
    var velocity: CGPoint = .zero
//    @Published var bounds: CGRect = .zero

    func resetVelocity() {
        nodes.forEach { node in
            node.position = node.position + node.velocity
            node.velocity = .zero
        }
    }

    func startLayout() {
        guard !isLayouting else { return }

        print("Layout started")

        isLayouting = true

        nodes.forEach {
            $0.velocity = .zero
            $0.stability = 1
            $0.moving = true
        }
        velocity = .zero

        doLayout()
    }

    var bounds: CGRect {
        nodes.reduce(CGRect.zero) { bounds, node in
            bounds.union(node.bounds)
        }
    }

    var movement: CGFloat = .infinity

    func dispatch(_ closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(1000))) {
            closure()
        }
    }

    func doLayout() {
        guard let layouter, isLayouting else {
            return
        }

        objectWillChange.send()
        layouter.layout(graph: self)

        let lastVelocity = velocity
        velocity = .zero

//        for node in nodes {
//            node.position = node.position + node.velocity
//            velocity = velocity + node.velocity
//            node.velocity = .zero
//        }

        let action = (lastVelocity - velocity).length
//        print("\(size.length)")

//        if action < 0.06 // || action > 2 * movement
//        { stopLayout() }
        movement = action

        if layouter.equilibrium {
            stopLayout()
        } else {
            dispatch {
                self.doLayout()
            }
        }
    }

    func stopLayout() {
        isLayouting = false
        print("Layout stopped")
    }

    deinit {
        print("Deinit")
    }
}

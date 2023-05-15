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
    func layout(graph: Graph)
}

class Graph: IdentifiableObject, ObservableObject {
    @Published var nodes: [GraphNode] = []
    var edges: [Edge] {
        nodes.compactMap { $0 as? Edge }
    }

    var layouter: GraphLayouter?
    @Published var isLayouting = false
    @Published var layoutPaused = false
//    @Published var bounds: CGRect = .zero

    func resetVelocity() {
        nodes.forEach { node in
            node.position = node.position + node.velocity
            node.velocity = .zero
        }
    }

    func startLayout() {
        guard !isLayouting, !layoutPaused else { return }

        print("Layout started")

        isLayouting = true
        layoutPaused = false

        nodes.forEach {
            $0.velocity = .zero
            $0.stability = 1
            $0.moving = true
        }

        doLayout()
    }

    var bounds: CGRect {
        nodes.reduce(CGRect.zero) { bounds, node in
            bounds.union(node.bounds)
        }
    }

    func doLayout() {
        guard let layouter, isLayouting, !layoutPaused else {
            return
        }

        objectWillChange.send()
        layouter.layout(graph: self)

        for node in nodes {
            node.position = node.position + node.velocity
            node.velocity = .zero
        }

        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(1))) {
            self.doLayout()
        }
    }

    func stopLayout() {
        isLayouting = false
        layoutPaused = false
        print("Layout stopped")
    }

    func pauseLayout() {
        guard isLayouting, !layoutPaused else { return }
        layoutPaused = true
        print("Layout paused")
    }

    func resumeLayout() {
        guard layoutPaused else { return }
        layoutPaused = false
        isLayouting = false
        print("Layout resuming")
        startLayout()
    }

    deinit {
        print("Deinit")
    }
}

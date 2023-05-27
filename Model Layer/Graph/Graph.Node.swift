//
//  Graph.Node.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.05.23.
//

import Foundation
import Smaug
import SwiftUI

extension Graph {
    class Node: IdentifiableObject, ObservableObject {
        var type: GraphNodeType = .testNode
        @Published var position: CGPoint = .random(in: 100 ..< 600)
        var velocity: CGPoint = .zero
        var size: CGSize = .zero

        var moving = true
        var unstoppable = false
        @Published var fixed = false
        @Published var visible = true
        var stability: CGFloat = 1
        var links: [Node] = []

        var mass: CGFloat {
            CGFloat(type.mass)
        }

        var charge: CGFloat {
            CGFloat(type.charge)
        }

        var bounds: CGRect {
            CGRect(center: position, size: size)
        }

        func start() {
            moving = true
            links.forEach { $0.start() }
        }

        func stop() {
            moving = unstoppable
        }

        @ViewBuilder
        var body: AnyView {
            AnyView(bodyCreator())
        }

        var bodyCreator: () -> any View = { EmptyView() }
    }
}

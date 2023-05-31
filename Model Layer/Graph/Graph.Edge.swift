//
//  Graph.Edge.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.05.23.
//

import Foundation
import SwiftUI

extension Graph {
    class Edge: Node {
        @Observed var to: Node
        @Observed var from: Node

        var alignment: Alignment?

        init(from: Node, to: Node) {
            super.init()
            self.type = .testEdge
            self.from = from
            self.to = to
            self.position = CGRect(firstPoint: from.position, secondPoint: to.position).center
            from.links.append(self)
            to.links.append(self)
            links.append(from)
            links.append(to)
        }

        override func start() {
            moving = true
        }

        override func stop() {
            moving = from.moving || to.moving
        }

        let strokeStyle = StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, miterLimit: .zero, dash: [], dashPhase: 0)
        let pointerLineLength: CGFloat = 10
        let arrowAngle: CGFloat = 120

        @ViewBuilder
        override var body: AnyView {
            AnyView(
                //                Text("Hallo\nWelt")
                Circle()
                    .frame(width: 2, height: 2)
                    .foregroundColor(Color.blue)
            )
        }

        var path: Path {
            let start = from.bounds.borderPoint(to: position)
            let end = to.bounds.padding(6).borderPoint(to: position)
            let mid = CGRect(firstPoint: start, secondPoint: end).controlPoint(for: position)

            var path = Path()
            guard !start.isNaN, !end.isNaN, !mid.isNaN else { return path }

            if from == to {
                path.move(to: start)
                let first = CGRect(firstPoint: start, secondPoint: position)
                let second = CGRect(firstPoint: position, secondPoint: end)
                path.addQuadCurve(to: position, control: first.controlPoint(for: first.center * 0.9))
                path.addQuadCurve(to: end, control: second.controlPoint(for: second.center * 1.1))
            } else {
                path.move(to: start)
                path.addQuadCurve(to: end, control: mid)
            }
            
            let startEndAngle = atan((end.y - mid.y) / (end.x - mid.x)) + ((end.x - mid.x) < 0 ? CGFloat(Double.pi) : 0)
            let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
            let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))

            path.addLine(to: arrowLine1)
            path.move(to: end)
            path.addLine(to: arrowLine2)
            path.closeSubpath()
            return path
        }
    }
}

//
//  Graph.Edge.swift
//  Hippocampus
//
//  Created by Guido Kühn on 15.05.23.
//

import Foundation
import SwiftUI

extension Graph {
    class Edge: GraphNode {
        var to: GraphNode
        var from: GraphNode
        var controlPoint: CGPoint = .zero

        init(from: GraphNode, to: GraphNode) {
            self.from = from
            self.to = to
            super.init()
            self.type = .trial
        }

        let strokeStyle = StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, miterLimit: .zero, dash: [], dashPhase: 0)
        let pointerLineLength: CGFloat = 10
        let arrowAngle: CGFloat = 120

        @ViewBuilder
        override var body: AnyView {
            AnyView(
                Text("Hallo")
//                Circle()
//                    .frame(width: 5, height: 5)
//                    .background(Color.red)
            )
        }

        var path: Path {
            let start = from.bounds.borderPoint(to: position)
            let end = to.bounds.padding(6).borderPoint(to: position)
            let mid = CGRect(firstPoint: start, secondPoint: end).controlPoint(for: position)
//            var mid = 2 * position
//            mid = CGPoint(mid - (start / 2))
//            mid = CGPoint(mid - (end / 2))

            var path = Path()
            path.move(to: start)
            path.addQuadCurve(to: end, control: mid)

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

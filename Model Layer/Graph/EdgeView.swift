//
//  EdgeView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 13.05.23.
//

import SwiftUI

struct EdgeView: View {
    @ObservedObject var edge: Graph.Edge

    let strokeStyle = StrokeStyle(lineWidth: 3, lineCap: .butt, lineJoin: .round, miterLimit: .zero, dash: [], dashPhase: 0)
    let pointerLineLength: CGFloat = 10
    let arrowAngle: CGFloat = 120

    var start: CGPoint {
        edge.from.bounds.borderPoint(to: edge.to.position)
    }

    var end: CGPoint {
        edge.to.bounds.borderPoint(to: edge.from.position)
    }

    var bounds: CGRect {
        let topLeft = min(start, end)
        let bottomRight = max(start, end)
        return CGRect(origin: topLeft, size: bottomRight - topLeft)
    }

    var center: CGPoint {
        (end + start) / 2
    }

    var path: Path {
        let mid = edge.position
        
        var path = Path()
        path.move(to: start)
        path.addQuadCurve(to: end, control: edge.position)

        let startEndAngle = atan((end.y - mid.y) / (end.x - mid.x)) + ((end.x - mid.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))

        path.addLine(to: arrowLine1)
        path.move(to: end)
        path.addLine(to: arrowLine2)
        return path
    }

    var body: some View {
//        Canvas { context, size in
//            let start = CGPoint.zero
//            let end = CGPoint(x: size.width, y: size.height)
//
//
//            context.stroke(path, with: .color(.black), style: strokeStyle)
//        }
//        .frame(width: bounds.width, height: bounds.height)
        path
            .stroke(style: strokeStyle)
            .foregroundColor(.red)
    }
}

struct EdgeView_Previews: PreviewProvider {
    static let node1 = {
        let result = Graph.GraphNode()
        result.position = CGPoint(x: 10, y: 10)
        return result
    }()

    static let node2 = {
        let result = Graph.GraphNode()
        result.position = CGPoint(x: 310, y: 310)
        return result
    }()

    static let edge = {
        let result = Graph.Edge(from: node1, to: node2)
        result.position = CGPoint(x: 10, y: 300)
        return result
    }()

    static var previews: some View {
        EdgeView(edge: edge)
    }
}

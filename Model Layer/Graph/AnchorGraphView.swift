//
//  AnchorGraphView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 21.05.23.
//

import SwiftUI

struct AnchorGraphView: View {
    @ObservedObject var graph: AnchorGraph
    @State var location: CGPoint = .zero
    @State var originalLocation: CGPoint = .zero
    @State var scale: CGFloat = 1
    @State var originalScale: CGFloat = 0

    func path(edge: AnchorGraph.Edge) -> Path {
        var path = Path()
        let controlpoint = CGRect(firstPoint: edge.node.position, secondPoint: edge.otherNode.position).controlPoint(for: edge.position)
        path.move(to: edge.node.position)
        path.addQuadCurve(to: edge.otherNode.position, control: controlpoint)
        return path
    }

    var zoomGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                if originalScale == 0 {
                    originalScale = scale
                    originalLocation = location
                }
                scale = originalScale * value
                location = originalLocation * value
            }
            .onEnded { value in
                scale = originalScale * value
                location = originalLocation * value
                originalScale = 0
                originalLocation = .zero
            }
    }

    var scrollGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if originalLocation == .zero {
                    originalLocation = location
                }
                location = originalLocation + value.translation
            }
            .onEnded { value in
                location = originalLocation + value.translation
                originalLocation = .zero
            }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(0 ..< graph.nodes.count, id: \.self) { index in
                let node = graph.nodes[index]
                if node is AnchorGraph.Edge {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.blue)
                        .position(node.position)
                } else {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.pink)
                        .position(node.position)
                }
            }
            ForEach(0 ..< graph.edges.count, id: \.self) { index in
                let edge = graph.edges[index]

                path(edge: edge)
                    .stroke()
                    .foregroundColor(.cyan)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scaleEffect(scale)
        .offset(position: location)
        .background(Color.background)
        .gesture(scrollGesture)
        .gesture(zoomGesture)
        .onAppear {
            graph.startLayout()
        }
    }
}

struct AnchorGraphView_Previews: PreviewProvider {
    static var graph: AnchorGraph = {
        let result = AnchorGraph()
        let a = AnchorGraph.Node()
        let b = AnchorGraph.Node()
        let c = AnchorGraph.Node()
        result.nodes.append(a)
        result.nodes.append(b)
        result.nodes.append(c)
        result.nodes.append(AnchorGraph.Edge(node: a, otherNode: b))
        result.nodes.append(AnchorGraph.Edge(node: b, otherNode: c))
        result.nodes.append(AnchorGraph.Edge(node: c, otherNode: a))

        return result
    }()

    static var previews: some View {
        AnchorGraphView(graph: graph)
    }
}

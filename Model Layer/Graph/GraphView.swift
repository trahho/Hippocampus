//
//  GraphView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 14.05.23.
//

import SwiftUI

struct GraphView: View {
    @ObservedObject var graph: Graph

    @State var location: CGPoint = .zero
    @State var originalLocation: CGPoint = .zero
    @State var scale: CGFloat = 1
    @State var originalScale: CGFloat = 0

    var zoomGesture: some Gesture { MagnificationGesture()
        .onChanged { value in
//            graph.pauseLayout()
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
//            graph.resumeLayout()
        }
    }

    var scrollGesture: some Gesture { DragGesture()
        .onChanged { value in
//            graph.pauseLayout()
            if originalLocation == .zero {
                originalLocation = location
            }
            location = originalLocation + value.translation
        }
        .onEnded { value in
            location = originalLocation + value.translation
            originalLocation = .zero
//            graph.resumeLayout()
        }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(graph.edges, id: \.self) { edge in
                edge.path.stroke(style: edge.strokeStyle)
                    .foregroundColor(.cyan)
            }
//            ForEach(graph.edges, id: \.self) { edge in
//                edge.body
//                    .offset(position: edge.bounds.topLeft)
//                    .measureSize(in: Binding(get: { edge.size }, set: { edge.size = $0 }))
//            }
            ForEach($graph.nodes, id: \.self) { $node in
                if let edge = node as? Graph.Edge {
                    edge.body
                        .measureSize(in: $node.size)
                        .position(node.position)
                } else {
                    node.body
                        .padding(10)
                        .background(Color.pink)
//                        .offset(position: node.position)
                        .measureSize(in: $node.size)
                        .position(node.position)
                        .gesture(DragGesture()
                            .onChanged { value in
                                node.fixed = true
                                node.position = value.location // - node.size / 2
                                if !graph.layoutPaused { graph.startLayout() }
                            }
                            .onEnded { value in
                                node.fixed = false
                                node.position = value.location // - node.size / 2
                            }
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scaleEffect(scale)
        .offset(position: location)
//        .background(graph.isLayouting ? Color.gray : Color.white)
        .background(Color.background)
        .toolbar {
            if graph.isLayouting {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if graph.layoutPaused {
                        Image(systemName: "pause.circle")
                            .onTapGesture {
                                graph.resumeLayout()
                            }
                    } else {
                        ProgressView()
                            .onTapGesture {
                                graph.pauseLayout()
                            }
                    }
                }
            }
        }

        .gesture(scrollGesture)
        .gesture(zoomGesture)
        .onLongPressGesture(perform: {
            if graph.isLayouting, !graph.layoutPaused {
                graph.pauseLayout()
            } else {
                graph.resumeLayout()
            }
        })
        .onAppear { graph.startLayout() }
        .onChange(of: graph) { [graph] newGraph in
            graph.stopLayout()
            newGraph.startLayout()
        }
    }
}

// struct GraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphView()
//    }
// }

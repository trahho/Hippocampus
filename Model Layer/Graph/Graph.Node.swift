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
        var type: GraphNodeType = .knot


        @ViewBuilder
        var body: AnyView {
            AnyView(EmptyView())
        }


//        func callAsFuntion() -> some View {
//            body
//        }

//        func b() -> some View {
//
//        }

        @Published var position: CGPoint = .init(x: Int.random(in: -100...100), y: Int.random(in: -100...100))
        var size: CGSize = .zero
        var bounds: CGRect {
            CGRect(center: position, size: size)
        }
        
        internal var layoutBounds: CGRect {
            CGRect(center: position + velocity, size: size)
        }

        var velocity: CGPoint = .zero
        var moving = true
        var stability: CGFloat = 1
        var unstoppable = false
        @Published var fixed = false
        var visible = true

        var mass: CGFloat {
            CGFloat(type.mass)
        }

        var charge: CGFloat {
            CGFloat(type.charge)
        }
    }
}

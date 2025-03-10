//
//  Design.BorderPointView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 14.05.23.
//

import SwiftUI

struct Design_BorderPointView: View {
    @State var offset: CGPoint = .init(x: 100, y: 100)
    @State var rect = CGRect(x: 400, y: 400, width: 200, height: 100)
    var size = CGSize(width: 20, height: 20)

    var circlePoint: CGPoint {
        let size = size / 2
        let circlePoint = CGPoint(.zero + (offset - rect.center) / (offset - rect.center).length)
        return circlePoint * size
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: rect.width, height: rect.height)
                .position(rect.center)
                .overlay {
                    Text("(\(circlePoint.x), \(circlePoint.y))")
                }
            Circle()
                .foregroundColor(.yellow)
                .frame(width: 10, height: 10)
                .position(rect.center)
            Circle()
                .foregroundColor(.green)
                .frame(width: 10, height: 10)
                .position(rect.center + circlePoint * 20)
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: rect.width, height: rect.height)
                .position(offset)
            Circle()
                .foregroundColor(.pink)
                .frame(width: 10, height: 10)
                .position(CGRect(center: offset, size: rect.size).borderPoint(to: rect.center))
            Circle()
                .foregroundColor(.pink)
                .frame(width: 10, height: 10)
                .position(CGRect(center: offset, size: rect.size).oppositeBorderPoint(to: rect.center))
            Circle()
                .foregroundColor(.red)
                .frame(width: size.width, height: size.height)
                .gesture(DragGesture()
                    .onChanged { value in
                        print("\(value.location)")
                        offset = offset + value.location - size / 2
                    }
                )
                .position(offset)
            Circle()
                .foregroundColor(.orange)
                .frame(width: 10, height: 10)
                .position(rect.borderPoint(to: offset))
            Circle()
                .foregroundColor(.orange)
                .frame(width: 10, height: 10)
                .position(rect.oppositeBorderPoint(to: offset))
        }
    }
}

struct Design_BorderPointView_Previews: PreviewProvider {
    static var previews: some View {
        Design_BorderPointView()
    }
}

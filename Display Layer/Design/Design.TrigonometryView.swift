//
//  Design.TrigonometryView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 03.06.23.
//

import SwiftUI

struct Design_TrigonometryView: View {
    @State var point1: CGPoint = .init(x: 500, y: 400)
    @State var point2: CGPoint = .init(x: 600, y: 400)
    @State var center: CGPoint = .init(x: 400, y: 400)
    var size = CGSize(width: 25, height: 25)

    var angle1: CGFloat {
        (point1 - center).angle.degrees
    }

    var angle2: CGFloat {
        atan2(point2.y - center.y, point2.x - center.x) * 180 / Double.pi
    }

    var angleBetween: CGFloat {
        let angle1 = (point1-center).angle
        let angle2 = (point2-center).angle
        let angle = angle2 - angle1

        //    if angle < 0 {
        //        angle += 2 * Double.pi
        //    }
        //
        return angle.degrees //< 0 ? -angle.degrees : angle.degrees
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                Text("\(angle1)")
                    .font(.myTitle)
                Text("\(angle2)")
                    .font(.myTitle)
                Text("\(angleBetween)")
                    .font(.myTitle)
            }
            Circle()
                .foregroundColor(.yellow)
                .frame(width: size.width, height: size.height)
                .position(center)
            
            Circle()
                .foregroundColor(.gray)
                .frame(width: size.width, height: size.height)
                .position(center + 10 * size.rotate(by: Angle(degrees: angleBetween)))
            
            Circle()
                .foregroundColor(.red)
                .frame(width: size.width, height: size.height)
                .gesture(DragGesture()
                    .onChanged { value in
                        point1 = point1 + value.location - size / 2
                    }
                )
                .position(point1)
            Circle()
                .foregroundColor(.green)
                .frame(width: size.width, height: size.height)
                .gesture(DragGesture()
                    .onChanged { value in
                        point2 = point2 + value.location - size / 2
                    }
                )
                .position(point2)
        }
    }
}

struct Design_TrigonometryView_Previews: PreviewProvider {
    static var previews: some View {
        Design_TrigonometryView()
    }
}

//
//  MathView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.05.23.
//

import SwiftUI

struct Design_MathView: View {
    @State var offset: CGPoint = .init(x: 100, y: 100)
    @State var rect = CGRect(x: 400, y: 400, width: 200, height: 100)
    @State var charge: CGFloat = 1
    @State var mass: CGFloat = 1
    var size = CGSize(width: 20, height: 20)
    var bounds: CGRect {
        CGRect(center: offset, size: rect.size)
    }

    var attractingSize: CGFloat {
        attracting.length * 100
    }
    var repellingSize: CGFloat {
        repelling.length * 100
    }

    var repelling: CGSize {
        let point = rect.borderPoint(to: bounds.center)
        let otherPoint = bounds.borderPoint(to: rect.center)
        
        let force = (point - otherPoint).length.square
        let repelling = (otherPoint - point) * charge / force
        
        return repelling
    }
    
    var attracting: CGSize {
        let point = rect.borderPoint(to: bounds.center)
        let otherPoint = bounds.borderPoint(to: rect.center)
        
        let force = (point - otherPoint).length
        print("force: \(force)")
        let attracting = mass * (otherPoint - point) / force
        return attracting
    }
    
    @ViewBuilder
    func picker(selection: Binding<CGFloat>) -> some View {
        Picker(selection: selection) {
            ForEach(0 ..< 100) { i in
                Text("\(i)")
                    .tag(CGFloat(i))
            }
        } label: {
            EmptyView()
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: rect.width, height: rect.height)
                .position(rect.center)
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: bounds.width, height: bounds.height)
                .position(bounds.center)
            
            Circle()
                .foregroundColor(.yellow)
                .frame(width: 10, height: 10)
                .position(rect.center)
            Circle()
                .foregroundColor(.red)
                .frame(width: size.width, height: size.height)
                .gesture(DragGesture()
                    .onChanged { value in
                        offset = offset + value.location - size / 2
//                        attractingSize = attracting.length
//                        repellingSize = repelling.length
//                        print("attracting \(attractingSize) repelling \(repellingSize)")
                    }
                )
                .position(offset)
            
            Circle()
                .foregroundColor(.orange)
                .frame(width: 10, height: 10)
                .position(rect.borderPoint(to: bounds.center))
            
            Circle()
                .foregroundColor(.pink)
                .frame(width: 10, height: 10)
                .position(bounds.borderPoint(to: rect.center))
            Grid(alignment: .topLeading) {
                GridRow {
                    Image(systemName: "square.and.arrow.down")
                    picker(selection: $mass)
                    Rectangle()
                        .foregroundColor(.green)
                        .frame(width: attractingSize, height: 20)
                }
                GridRow {
                    Image(systemName: "square.and.arrow.up")
                    picker(selection: $charge)
                    Rectangle()
                        .foregroundColor(.red)
                        .frame(width: repellingSize, height: 20)
                }
//                Path { path in
//                    let start = rect.borderPoint(to: bounds.center)
//                    let end = start + repelling
//                    path.move(to: start)
//                    path.addLine(to: end)
//                }
//                .stroke()
            }
            .font(Font.myHeader)
        }
        .onAppear {
//            attractingSize = attracting.length
//            repellingSize = repelling.length
        }
    }
}

struct Design_MathView_Previews: PreviewProvider {
    static var previews: some View {
        Design_MathView()
    }
}

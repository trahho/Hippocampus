//
//  PresentationView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.06.24.
//

import Foundation
import SwiftUI

// extension Presentation {
//    @ViewBuilder func presentation(for item: Information.Item) -> some View {
//        switch self {
//        case .label(let string):
//            Text(verbatim: string)
////            case .color(let child, let color):
////                child.presentation(for: item)
////                    //                Rectangle()
////                    .foregroundStyle(color)
////            //                    .foregroundStyle(color)
////            //            case .background(let child, let color):
////            //                PresentationView(presentation: child, item: item)
////            //                    .backgroundStyle(color)
//        case .horizontal(let children, alignment: let alignment):
//            HStack(alignment: alignment.vertical) {
//                ForEach(0 ..< children.count, id: \.self) { i in
//                    children[i].presentation(for: item)
//                }
////                    ForEach(children, id:\.self) {child in
////                        child.presentation(for: item)
////                    }
//            }
//        case .vertical(let children, alignment: let alignment):
//            VStack(alignment: alignment.horizontal) {
//                ForEach(0 ..< children.count, id: \.self) { i in
//                    children[i].presentation(for: item)
//                }
//            }
//        default:
//            EmptyView()
//        }
//    }
// }

struct PresentationView: View {
    @State var presentation: Presentation
    @State var item: Information.Item
    @State var id = UUID()

    init(presentation: Presentation, item: Information.Item) {
        self.presentation = presentation
        self.item = item
    }

    struct ArrayView: View {
        @State var array: [Presentation]
        @State var item: Information.Item

        var body: some View {
            ForEach(array, id: \.self) { presentation in
//            if let presentation = array.first{
                PresentationView(presentation: presentation, item: item) // .id(UUID())
            }
        }
    }

    var body: some View {
//        presentation.presentation(for: item)
//        Group {
        switch presentation {
        case .check(let child):
            ArrayView(array: child, item: item)
        case .label(let string):
            Text(string).id(UUID())
        case .background(let children, let color):
            ArrayView(array: children, item: item)
                .background(color)
        case .color(let children, let color):
            ArrayView(array: children, item: item)

                //                Rectangle()
                .foregroundStyle(color)
        //                    .foregroundStyle(color)
        //            case .background(let child, let color):
        //                PresentationView(presentation: child, item: item)
        //                    .backgroundStyle(color)
        case .horizontal(let children, alignment: let alignment):
            HStack(alignment: alignment.vertical) {
                ArrayView(array: children, item: item)
            }
        case .vertical(let children, alignment: let alignment):
            VStack(alignment: alignment.horizontal) {
                ArrayView(array: children, item: item)
            }
        case .grouped(let children):
            ArrayView(array: children, item: item).padding()
        default:
            EmptyView()
        }
        //                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
//        }
//        .id(UUID())
    }
}

#Preview {
//    @State var document = HippocampusApp.editStaticRolesDocument
    PresentationView(presentation: Structure.Role.hierarchical.representations[0].presentation, item: Information.Item())
}

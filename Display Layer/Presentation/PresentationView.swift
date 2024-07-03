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
    @Environment(Document.self) var document
    @State var presentation: Presentation
    @State var item: Information.Item?
    @State var id = UUID()

    struct ArrayView: View {
        @State var array: [Presentation]
        @State var item: Information.Item?

        var body: some View {
            ForEach(array, id: \.self) { presentation in
//            if let presentation = array.first{
                PresentationView(presentation: presentation, item: item) // .id(UUID())
            }
        }
    }

    var body: some View {
        switch presentation {
        case .label(let string):
            Text(string).id(UUID())
        case .aspect(let aspectId, let appearance):
            if let aspect = document[Structure.Aspect.self, aspectId] {
                AspectView(aspect: aspect, appearance: appearance, editable: false)
            }
        case .background(let children, let color):
            ArrayView(array: children, item: item)
                .background(color)
        case .color(let children, let color):
            ArrayView(array: children, item: item)
                .foregroundStyle(color)
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
    }
    
    struct Preview: View {
        let presentation: Presentation =
            .vertical([
                    .aspect("6247260E-624C-48A1-985C-CDEDDFA5D3AD".uuid, appearance: .normal),
                    .aspect("F0C2B7D0-E71A-4296-9190-8EF2D540338F".uuid, appearance: .normal),
                    .aspect("F0C2B7D0-E71A-4296-9190-8EF2D540338F".uuid, appearance: .normal)
            ], alignment: .center)
        var body: some View {
            PresentationView(presentation: presentation, item: nil)
               .environment(HippocampusApp.editStaticRolesDocument)
        }
    }
}

#Preview {
    PresentationView.Preview()
}

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
    // MARK: Nested Types

    struct ArrayView: View {
        // MARK: Properties

        @State var array: [Presentation]
        @State var item: Information.Item?

        // MARK: Content

        var body: some View {
            ForEach(array, id: \.self) { presentation in
//            if let presentation = array.first{
                PresentationView(presentation: presentation, item: item) // .id(UUID())
            }
        }
    }

    struct Preview: View {
        // MARK: Properties

        let presentation: Presentation =
            .vertical([
                .aspect("6247260E-624C-48A1-985C-CDEDDFA5D3AD".uuid, appearance: .normal),
                .aspect("F0C2B7D0-E71A-4296-9190-8EF2D540338F".uuid, appearance: .normal),
                .aspect("F0C2B7D0-E71A-4296-9190-8EF2D540338F".uuid, appearance: .normal),
            ], alignment: .center)

        // MARK: Content

        var body: some View {
            PresentationView(presentation: presentation, item: nil)
                .environment(HippocampusApp.editStaticRolesDocument)
        }
    }

    // MARK: Properties

    @Environment(\.document) var document
    @State var presentation: Presentation
    @State var item: Information.Item?
    @State var id = UUID()

    // MARK: Content

    var body: some View {
        Group {
            switch presentation {
            case let .label(string):
                Text(string).sensitive
            case let .icon(iconId):
                Image(systemName: iconId)
            case let .role(roleId, layout, name):
                if let role = document[Structure.Role.self, roleId],
                   let role = item?.matchingRole(for: role),
                   let presentation = role.representation(layout: layout, name: name)?.presentation
                {
                    ArrayView(array: [presentation], item: item)
                }
            case let .aspect(aspectId, appearance):
                if let aspect = document[Structure.Aspect.self, aspectId] {
                    AspectView(item: item, aspect: aspect, appearance: appearance, editable: false)
                }
            case let .background(children, color):
                ArrayView(array: children, item: item)
                    .background(color)
            case let .color(children, color):
                ArrayView(array: children, item: item)
                    .foregroundStyle(color)
            case let .horizontal(children, alignment: alignment):
                HStack(alignment: alignment.vertical) {
                    ArrayView(array: children, item: item)
                }
            case let .vertical(children, alignment: alignment):
                VStack(alignment: alignment.horizontal) {
                    ArrayView(array: children, item: item)
                }
            case let .grouped(children):
                ArrayView(array: children, item: item).padding()
            case let .spaced(children, horizontal, vertical):
                ArrayView(array: children, item: item)
                    .containerRelativeFrame([.horizontal, .vertical], alignment: Alignment(horizontal: horizontal.alignment.horizontal, vertical: vertical.alignment.vertical)) { size, axis in
                        if axis == .horizontal {
                            return size * horizontal.factor
                        } else {
                            return size * vertical.factor
                        }
                    }
            //            switch horizontal {
            //            case .full(let horizontal):
            //                switch vertical {
            //                case .full(let vertical):
            //                    ArrayView(array: children, item: item)
            //                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .init(horizontal: horizontal.horizontal, vertical: vertical.vertical))
            //                case .normal:
            //                    ArrayView(array: children, item: item)
            //                        .frame(maxWidth: .infinity, alignment: .init(horizontal: horizontal.horizontal, vertical: .center))
            //                case .percent(let percent, let vertical):
            //                    ArrayView(array: children, item: item)
            //                        .frame(maxWidth: .infinity)
            //                        .containerRelativeFrame(.vertical) { height, _ in
            //                            height * CGFloat(percent)
            //                        }
            //                }
            //
            //            case .normal:
            //                switch vertical {
            //                case .full(let vertical):
            //                    ArrayView(array: children, item: item)
            //                        .frame(maxHeight: .infinity, alignment: .init(horizontal: .center, vertical: vertical.vertical))
            //                case .normal:
            //                    ArrayView(array: children, item: item)
            //                case .percent(let percent, let vertical):
            //                    ArrayView(array: children, item: item)
            //                        .containerRelativeFrame(.vertical) { height, _ in
            //                            height * CGFloat(percent)
            //                        }
            //                }
            //
            //            case .percent(let horizontalPercent, let horizontal):
            //                switch vertical {
            //                case .full(let vertical):
            //                    ArrayView(array: children, item: item)
            //                        .frame(maxHeight: .infinity, alignment: .init(horizontal: horizontal.horizontal, vertical: vertical.vertical))
            //                        .containerRelativeFrame(.horizontal) { width, _ in width * CGFloat(horizontalPercent) }
            //                case .normal:
            //                    ArrayView(array: children, item: item)
            //                        .frame(alignment: .init(horizontal: horizontal.horizontal, vertical: .center))
            //                        .containerRelativeFrame(.horizontal) { width, _ in width * CGFloat(horizontalPercent) }
            //                case .percent(let verticalPercent, let vertical):
            //                    ArrayView(array: children, item: item)
            //                        .containerRelativeFrame([.horizontal, .vertical]) { size, axis in
            //                            if axis == .vertical {
            //                                return size * CGFloat(verticalPercent)
            //                            } else {
            //                                return size * CGFloat(horizontalPercent)
            //                            }
            //                        }
            //                }
            //            }
            default:
                EmptyView()
            }
        }
        .sensitive
    }
}

#Preview {
    PresentationView.Preview()
}

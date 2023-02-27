//
//  Arrangement.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.01.23.
//

import Foundation
import SwiftUI

extension Structure {
    indirect enum Representation {
        case horizontal([Representation], alignment: VerticalAlignment = VerticalAlignment.top)
        case vertical([Representation], alignment: HorizontalAlignment = HorizontalAlignment.leading)
        case aspect(Structure.Aspect, editable: Bool = true)

        @ViewBuilder
        func view(for item: Information.Item, editable: Bool) -> some View {
            switch self {
            case let .horizontal(children, alignment):
                HorizontalView(item: item, children: children, alignment: alignment, editable: editable)
            case let .vertical(children, alignment):
                VerticalView(item: item, children: children, alignment: alignment, editable: editable)
            case let .aspect(aspect, isEditable):
                aspect.view(for: item, editable: isEditable && editable)
            }
        }
    }

    struct HorizontalView: View {
        @ObservedObject var item: Information.Item
        var children: [Representation]
        var alignment: VerticalAlignment
        var editable: Bool

        var body: some View {
            HStack(alignment: alignment) {
                ForEach(0 ..< children.count, id: \.self) { index in
                    children[index].view(for: item, editable: editable)
                }
            }
        }
    }

    struct VerticalView: View {
        @ObservedObject var item: Information.Item
        var children: [Representation]
        var alignment: HorizontalAlignment
        var editable: Bool

        var body: some View {
            VStack(alignment: alignment) {
                ForEach(0 ..< children.count, id: \.self) { index in
                    children[index].view(for: item, editable: editable)
                }
            }
        }
    }
}

// extension Structure.Role.Representation: Identifiable {
//    var id: Int {
//        switch self {
//        case .aspect:
//            return 1
//        case .horizontal:
//            return 2
//        case .vertical:
//            return 3
//        }
//    }
// }

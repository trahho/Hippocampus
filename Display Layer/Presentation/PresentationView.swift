//
//  PresentationView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.06.24.
//

import Foundation
import SwiftUI

struct PresentationView: View {
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
                if let aspect = document[Structure.Aspect.self, aspectId], let item {
                    AspectItemView(item: item, aspect: aspect, appearance: appearance)
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
            default:
                EmptyView()
            }
        }
//        .sensitive
    }
}

//
//  File.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.06.24.
//

import Foundation
import SwiftUI

extension PresentationEditView {
    struct ContextMenu: View {
        // MARK: Properties

        @Binding var presentation: Presentation
        @Binding var array: [Presentation]

        // MARK: Computed Properties

        var children: [Presentation] {
            switch presentation {
            case let .horizontal(children, _),
                let .vertical(children, _),
                let .background(children, _),
                let .color(children, _),
                let .grouped(children),
                let .spaced(children, _, _):
                children
            default:
                []
            }
        }

        // MARK: Content

        var body: some View {
            Button {
                remove()
            } label: {
                Label("Remove", systemImage: "trash")
            }

            switch presentation {
            case .label:
                EmptyView()
            case .horizontal, .vertical, .spaced, .color, .background, .grouped:
                Menu("Add") {
                    Button("Label") { add(item: .label("")) }
                    Button("Icon") { add(item: .icon("")) }
                    Button("Aspect") { add(item: .aspect(.nil, appearance: .normal)) }
                    Button("Horizontal") { add(item: .horizontal([], alignment: .center)) }
                    Button("Vertical") { add(item: .vertical([], alignment: .center)) }
                    Button("Perspective presentation") { add(item: .perspective(.nil, layout: .list, name: nil)) }
                }
            case .undefined:
                Button("Label") { presentation = .label("") }
                Button("Icon") { presentation = .icon("") }
                Button("Aspect") { presentation = .aspect(.nil, appearance: .normal) }
                Button("Horizontal") { presentation = .horizontal([], alignment: .center) }
                Button("Vertical") { presentation = .vertical([], alignment: .center) }
                Button("Perspective presentation") { presentation = .perspective(.nil, layout: .list, name: nil) }
            default:
                EmptyView()
               
                
            }
            Menu("Wrap in") {
                Button("Horizontal") { presentation = .horizontal([presentation], alignment: .center) }
                Button("Vertical") { presentation = .vertical([presentation], alignment: .center) }
                Button("Group") { presentation = .grouped([presentation]) }
            }
            if case .color(_, _) = presentation { EmptyView()} else {
                Button("Foreground") { self.presentation = .color(presentation, color: Color(hex: "0000ff")) }
            }
            if case .background(_, _) = presentation { EmptyView()} else {
                Button("Background") { self.presentation = .background(presentation, color: Color(hex: "FFFFFF")) }
            }
//            switch presentation {
//            case .spaced: EmptyView()
//            default: Button("Size") { self.presentation = .spaced([presentation], horizontal: .normal, vertical: .normal) }
//            }
        }

        // MARK: Functions

        func add(item: Presentation) {
            switch presentation {
            case let .horizontal(children, alignment):
                presentation = .horizontal(children + [item], alignment: alignment)
            case let .vertical(children, alignment):
                presentation = .vertical(children + [item], alignment: alignment)
            default:
                break
            }
        }

        func remove() {
            guard let index = array.firstIndex(of: presentation) else { return }
            switch presentation {
            case let .horizontal(children, _), let .vertical(children, _):
                array.replaceSubrange(index ... index, with: children)
//            case .color(let presentation, let color), .background(let presentation, let color):
//                array[index] = presentation//.first!
            case let .background(children, _):
                array.replaceSubrange(index ... index, with: children)
            case let .color(children, _):
                array.replaceSubrange(index ... index, with: children)
            case let .spaced(children, _, _):
                array.replaceSubrange(index ... index, with: children)
            case let .grouped(children):
                array.replaceSubrange(index ... index, with: children)
            default:
                array.remove(at: index)
            }
        }
    }
}

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
            case let .horizontal(children, _), let .vertical(children, _):
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
            case .undefined:
                Button("Label") { presentation = .label("") }
                Button("Icon") { presentation = .icon("") }
                Button("Aspect") { presentation = .aspect(.nil, appearance: .normal) }
                Button("Horizontal") { presentation = .horizontal([], alignment: .center) }
                Button("Vertical") { presentation = .vertical([], alignment: .center) }
            default:
                Menu("Add") {
                    Button("Label") { add(item: .label("")) }
                    Button("Icon") { add(item: .icon("")) }
                    Button("Aspect") { add(item: .aspect(.nil, appearance: .normal)) }
                    Button("Horizontal") { add(item: .horizontal([], alignment: .center)) }
                    Button("Vertical") { add(item: .vertical([], alignment: .center)) }
                }
                Menu("Change to") {
                    Button("Label") { presentation = .label("") }
                    Button("Icon") { presentation = .icon("") }
                    Button("Aspect") { presentation = .aspect(.nil, appearance: .normal) }
                    Button("Horizontal") { presentation = .horizontal(children, alignment: .center) }
                    Button("Vertical") { presentation = .vertical(children, alignment: .center) }
                }
                Button("Group") { presentation = .grouped([presentation]) }
            }
            switch presentation {
            case .color: EmptyView()
            default: Button("Foreground") { self.presentation = .color(presentation, color: Color(hex: "0000ff")) }
            }
            switch presentation {
            case .background: EmptyView()
            default: Button("Background") { self.presentation = .background(presentation, color: Color(hex: "FFFFFF")) }
            }
            switch presentation {
            case .spaced: EmptyView()
            default: Button("Size") { self.presentation = .spaced([presentation], horizontal: .normal, vertical: .normal) }
            }
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
            case let .horizontal(children, alignment), let .vertical(children, alignment):
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

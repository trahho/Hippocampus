//
//  File.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.06.24.
//

import Foundation
import SwiftUI

extension PresentationEditView.ItemEditView {
    struct ContextMenu: View {
        @Binding var presentation: Presentation
        @Binding var array: [Presentation]

        func add(item: Presentation) {
            switch presentation {
            case .horizontal(let children, let alignment):
                presentation = .horizontal(children + [item], alignment: alignment)
            case .vertical(let children, let alignment):
                presentation = .vertical(children + [item], alignment: alignment)
            default:
                break
            }
        }

        func remove() {
            guard let index = array.firstIndex(of: presentation) else { return }
            switch presentation {
            case .horizontal(let children, let alignment), .vertical(let children, let alignment):
                array.replaceSubrange(index ... index, with: children)
//            case .color(let presentation, let color), .background(let presentation, let color):
//                array[index] = presentation//.first!
            default:
                array.remove(at: index)
            }
        }

        var children: [Presentation] {
            switch presentation {
            case .horizontal(let children, _), .vertical(let children, _):
                children
            default:
                []
            }
        }

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
                Button("Horizontal") { presentation = .horizontal([], alignment: .center) }
                Button("Vertical") { presentation = .vertical([], alignment: .center) }
            default:
                Menu("Add") {
                    Button("Label") { add(item: .label("")) }
                    Button("Horizontal") { add(item: .horizontal([], alignment: .center)) }
                    Button("Vertical") { add(item: .vertical([], alignment: .center)) }
                }
                Menu("Change to") {
                    Button("Label") { presentation = .label("") }
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
        }
    }
}

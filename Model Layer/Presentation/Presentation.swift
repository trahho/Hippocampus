//
//  Arrangement.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.01.23.
//

import Foundation
import Grisu
import SwiftUI

indirect enum Presentation: Structure.PersistentValue, Hashable, Transferable, SourceCodeGenerator {
    case empty
    case undefined
    case label(String)
    case icon(String)
    case aspect(Structure.Aspect.ID, appearance: Appearance)
    case horizontal([Presentation], alignment: Alignment)
    case vertical([Presentation], alignment: Alignment)
    case spaced([Presentation], horizontal: Space, vertical: Space)
    case color([Presentation], color: Color)
    case background([Presentation], color: Color)
    case grouped([Presentation])

    // MARK: Static Computed Properties

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Presentation.self, contentType: .text)
    }

    // MARK: Static Functions

    static func color(_ presentation: Presentation, color: Color) -> Presentation {
        .color([presentation], color: color)
    }

    static func background(_ presentation: Presentation, color: Color) -> Presentation {
        .background([presentation], color: color)
    }
    
    static func ascpect(_ aspect: Structure.Aspect, appearance: Appearance) -> Presentation {
        .aspect(aspect.id, appearance: appearance)
    }

    // MARK: Functions

    func sourceCode(tab i: Int, inline: Bool, document: Document) -> String {
        let start = inline ? "" : tab(i)
        switch self {
        case .empty:
            return start + ".empty"
        case .undefined:
            return start + ".undefined"
        case let .label(text):
            return start + ".label(\"\(text)\")"
        case let .icon(text):
            return start + ".icon(\"\(text)\")"
        case let .aspect(id, appearance):
//            if let aspect = document[Structure.Aspect.self, id] {
//                return start + ".aspect(Structure.Role.\(aspect.role.name).\(aspect.name), appearance: \(appearance.sourceCode(tab: 0, inline: true, document: document)))"
//            } else {
                return start + ".aspect(\"\(id)\".uuid, appearance: \(appearance.sourceCode(tab: 0, inline: true, document: document)))"
//            }
        case let .horizontal(presentations, alignment: alignment):
            return start + ".horizontal(["
                + presentations.map { $0.sourceCode(tab: i + 1, inline: false, document: document) }.joined(separator: ", ")
                + tab(i ) + "], alignment: \(alignment.sourceCode(tab: 0, inline: true, document: document)))"
        case let .vertical(presentations, alignment: alignment):
            return start + ".vertical(["
                + presentations.map { $0.sourceCode(tab: i + 1, inline: false, document: document) }.joined(separator: ", ")
            + tab(i ) + "], alignment: \(alignment.sourceCode(tab: 0, inline: true, document: document)))"
        case let .spaced(presentations, horizontal, vertical):
            return start + ".spaced(["
                + presentations.map { $0.sourceCode(tab: i + 1, inline: false, document: document) }.joined(separator: ", ")
            + tab(i ) + "], horizontal: \(horizontal.sourceCode(tab: 0, inline: true, document: document)), vertical: \(vertical.sourceCode(tab: 0, inline: true, document: document)))"
        case let .grouped(children):
            return start + ".grouped(["
                + children.map { $0.sourceCode(tab: i + 1, inline: false, document: document) }.joined(separator: ", ")
                + tab(i) + "])"
        case let .background(children, color):
            return start + ".background(["
                + children.map { $0.sourceCode(tab: i + 1, inline: false, document: document) }.joined(separator: ", ")
                + tab(i) + "], color: Color(hex: \"\(color.toHex!)\"))"
        case let .color(children, color):
            return start + ".color(["
                + children.map { $0.sourceCode(tab: i + 1, inline: false, document: document) }.joined(separator: ", ")
                + tab(i) + "], color: Color(hex: \"\(color.toHex!)\"))"
        }
    }
}

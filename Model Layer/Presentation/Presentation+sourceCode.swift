//
//  Presentation+sourceCode.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.07.24.
//

extension Presentation: SourceCodeGenerator {
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
        case let .perspective(id, layout, name):
//            if let perspective = document[Structure.Perspective.self, id], perspective.isStatic {
//                return start + ".perspective(Structure.Perspective.\(perspective.name.sourceCode).id, layout: .\(layout.description), name: \(name ?? "nil"))"
//            } else {
            return start + ".perspective(\"\(id)\".uuid, layout: .\(layout.description), name: \(name ?? "nil"))"
//            }
        case let .aspect(id, appearance):
            //            if let aspect = document[Structure.Aspect.self, id] {
            //                return start + ".aspect(Structure.Perspective.\(aspect.perspective.name).\(aspect.name), appearance: \(appearance.sourceCode(tab: 0, inline: true, document: document)))"
            //            } else {
            if let aspect = document[Structure.Aspect.self, id] {
                return start + ".aspect(\"\(id)\".uuid /*\(aspect.perspective?.name ?? aspect.particle?.name ?? "unknown").\(aspect.name)*/, appearance: \(appearance.sourceCode(tab: 0, inline: true, document: document)))"
            } else {
                return "Error: No Aspect"
            }
        //            }
        case let .horizontal(presentations, alignment: alignment):
            return start + ".horizontal(["
                + presentations.map { $0.sourceCode(tab: i + 1, inline: false, document: document) }.joined(separator: ", ")
                + tab(i) + "], alignment: \(alignment.sourceCode(tab: 0, inline: true, document: document)))"
        case let .vertical(presentations, alignment: alignment):
            return start + ".vertical(["
                + presentations.map { $0.sourceCode(tab: i + 1, inline: false, document: document) }.joined(separator: ", ")
                + tab(i) + "], alignment: \(alignment.sourceCode(tab: 0, inline: true, document: document)))"
        case let .spaced(presentations, horizontal, vertical):
            return start + ".spaced(["
                + presentations.map { $0.sourceCode(tab: i + 1, inline: false, document: document) }.joined(separator: ", ")
                + tab(i) + "], horizontal: \(horizontal.sourceCode(tab: 0, inline: true, document: document)), vertical: \(vertical.sourceCode(tab: 0, inline: true, document: document)))"
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

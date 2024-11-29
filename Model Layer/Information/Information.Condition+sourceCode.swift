//
//  Information.Condition+sourceCode.swift
//  Hippocampus
//
//  Created by Guido Kühn on 14.07.24.
//

extension Information.Condition: SourceCodeGenerator {
    func sourceCode(tab _: Int, inline: Bool, document: Document) -> String {
        switch self {
        case let .all(children):
            return children.map { $0.sourceCode(tab: 0, inline: true, document: document) }.joined(separator: " && ")
        case let .any(children):
            return "(" + children.map { $0.sourceCode(tab: 0, inline: true, document: document) }.joined(separator: " || ") + ")"
        case let .always(bool):
            return ".always(\(bool))"
        case .nil:
            return ".nil"
        case let .perspective(perspectiveId):
//            guard let perspective = document[Structure.Perspective.self, perspectiveId], perspective.isStatic else {
            return ".perspective(\"\(perspectiveId.uuidString)\".uuid)"
//            return ".perspective(Structure.Perspective.\(perspective.name.sourceCode).id)"
        case let .hasParticle(particleId, condition):
            let condition = condition.sourceCode(tab: 0, inline: true, document: document)
            guard let particle = document[Structure.Particle.self, particleId], particle.isLocked else { return ".hasParticle(\"\(particleId.uuidString)\".uuid, \(condition))" }
            return ".hasParticle(Structure.Perspective.\(particle.perspective.name.sourceCode).\(particle.name.sourceCode).id, \(condition))"
        case let .isParticle(particleId):
            return ".isParticle(\"\(particleId.uuidString)\".uuid)"
        case let .isReferenced(condition):
            return "(\(condition.sourceCode(tab: 0, inline: true, document: document)))<~"
        case let .isReferenceOfPerspective(perspectiveId):
            return ".isReferenceOfPerspective(\"\(perspectiveId.uuidString)\".uuid)"
        case let .hasReference(condition):
            return "~>(\(condition.sourceCode(tab: 0, inline: true, document: document))))"
        case let .hasValue(comparison):
            return ".hasValue(\(comparison.sourceCode(tab: 0, inline: true, document: document)))"
        case let .not(condition):
            return "!" + condition.sourceCode(tab: 0, inline: true, document: document)
        }
    }
}

extension Information.Condition.Comparison: SourceCodeGenerator {
    func sourceCode(tab: Int, inline: Bool, document: Document) -> String {
        switch self {
        case .nil:
            ".nil"
        case let .below(aspect, form, value):
            ".below(\"\(aspect)\".uuid, \(value.sourceCode(tab: tab, inline: true, document: document)))"
        case let .above(aspect, form, value):
            ".above(\"\(aspect)\".uuid, \(value.sourceCode(tab: tab, inline: true, document: document)))"
        case let .equal(aspect, value, form):
            ".equal(\"\(aspect)\".uuid, \(value.sourceCode(tab: tab, inline: true, document: document)))"
        case let .unequal(aspect, form, value):
            ".unequal(\"\(aspect)\".uuid, \(value.sourceCode(tab: tab, inline: true, document: document)))"
        case let .anyValue(aspect):
            ".anyValue(\"\(aspect)\".uuid)"
        }
    }
}

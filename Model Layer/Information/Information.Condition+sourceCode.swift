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
        case let .role(roleId):
//            guard let role = document[Structure.Role.self, roleId], role.isStatic else {
            return ".role(\"\(roleId.uuidString)\".uuid)"
//            return ".role(Structure.Role.\(role.name.sourceCode).id)"
        case let .hasParticle(particleId, condition):
            let condition = condition.sourceCode(tab: 0, inline: true, document: document)
            guard let particle = document[Structure.Particle.self, particleId], particle.isLocked else { return ".hasParticle(\"\(particleId.uuidString)\".uuid, \(condition))" }
            return ".hasParticle(Structure.Role.\(particle.role.name.sourceCode).\(particle.name.sourceCode).id, \(condition))"
        case let .isParticle(particleId):
            return ".isParticle(\"\(particleId.uuidString)\".uuid)"
        case let .isReferenced(condition):
            return "(\(condition.sourceCode(tab: 0, inline: true, document: document)))<~"
        case let .isReferenceOfRole(roleId):
            return ".isReferenceOfRole(\"\(roleId.uuidString)\".uuid)"
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

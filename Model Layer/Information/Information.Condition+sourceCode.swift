//
//  Information.Condition+sourceCode.swift
//  Hippocampus
//
//  Created by Guido Kühn on 14.07.24.
//

extension Information.Condition: SourceCodeGenerator {
    func sourceCode(tab i: Int, inline: Bool, document: Document) -> String {
        switch self {
        case .all(let children):
            return children.map { $0.sourceCode(tab: 0, inline: true, document: document) }.joined(separator: " && ")
        case .any(let children):
            return "(" + children.map { $0.sourceCode(tab: 0, inline: true, document: document) }.joined(separator: " || ") + ")"
        case .always(let bool):
            return ".always(\(bool))"
        case .nil:
            return ".nil"
        case .role(let roleId):
            guard let role = document[Structure.Role.self, roleId], role.isStatic else { return ".role(\"\(roleId.uuidString)\".uuid)"}
            return ".role(Structure.Role.\(role.name).id)"
        case .hasParticle(let particleId, let condition):
            let condition = condition.sourceCode(tab: 0, inline: true, document: document)
            guard let particle = document[Structure.Particle.self, particleId], particle.isStatic else { return ".hasParticle(\"\(particleId.uuidString)\".uuid, \(condition))"}
            return ".hasParticle(Structure.Role.\(particle.role.name).\(particle.name).id, \(condition))"
        case .isParticle(let particleId):
            return ".isParticle(\"\(particleId.uuidString)\".uuid)"
        case .isReferenced(let condition):
            return "(\(condition.sourceCode(tab: 0, inline: true, document: document)))<~"
        case .isReferenceOfRole(let roleId):
            return ".isReferenceOfRole(\"\(roleId.uuidString)\".uuid)"
        case .hasReference(let condition):
            return "~>(\(condition.sourceCode(tab: 0, inline: true, document: document))))"
        case .hasValue:
            return ""
        case .not(let condition):
            return "!" + condition.sourceCode(tab: 0, inline: true, document: document)
        }
    }
}

//
//  Structure.Role+sourceCode.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.06.24.
//

import Foundation

// extension Array: SourceCodeGenerator where Element : SourceCodeGenerator {
//    func sourceCode(tab i: Int, inline: Bool, document: Document) -> String {
//        if isEmpty { "" } else {
//
//        }
//    }
//
//
// }

extension Structure.Role: SourceCodeGenerator {
    func sourceCode(tab i: Int, inline _: Bool, document: Document) -> String {
        tab(i + 1) + "static let \(name.sourceCode): Role = {"
        + tab(i + 2) + "var role = Role(id: \"\(id)\".uuid)"
            + tab(i + 2) + "role.name = \"\(name)\""
            + rolesSourceCode(tab: i + 2)
            + referencesSourceCode(tab: i + 2)
            + aspectsSourceCode(tab: i + 2)
            + particlesSourceCode
            + representationsSourceCode(tab: i + 2, document: document)
            + tab(2) + "return role"
            + tab(1) + "}()" + cr
    }

    fileprivate func rolesSourceCode(tab i: Int) -> String {
        if roles.isEmpty { "" } else {
            tab(i) + "role.roles = ["
                + roles
                .map { ".\($0.name.sourceCode)" }
                .joined(separator: ", ")
                + "]"
        }
    }

    fileprivate func referencesSourceCode(tab i: Int) -> String {
        if references.isEmpty { "" } else {
            tab(i) + "role.references = ["
                + references
                .map { ".\($0.name.sourceCode)" }
                .joined(separator: ", ")
                + "]"
        }
    }

    fileprivate func aspectsSourceCode(tab i: Int) -> String {
        if aspects.isEmpty { "" } else {
            tab(i) + "role.aspects = ["
                + aspects.map { aspect in
                    tab(i + 1) + "{"
                        + tab(i + 2) + "let aspect = Aspect(id: \"\(aspect.id)\".uuid)"
                    + tab(i + 2) + "aspect.name = \"\(aspect.name)\""
                        + tab(i + 2) + "aspect.kind = .\(aspect.kind)"
                        + (aspect.exportCodedComputed ? (
                            tab(i + 2) + "aspect.codedComputation = Aspect.Code." + "\(aspect.role!.name) \(aspect.name)".sourceCode
                                + tab(i + 2) + "aspect.isComputed = true"
                        ) : "")
                        + tab(i + 2) + "return aspect"
                        + tab(i + 1) + "}()"
                }
                .joined(separator: ",")
                + tab(i) + "]"
        }
    }

    fileprivate func particleAspectsSourceCode(particle: Particle) -> String {
        if particle.aspects.isEmpty { "" } else {
            tab(4) + "particle.aspects = ["
                + particle.aspects.map { aspect in
                    tab(5) + "{"
                        + tab(6) + "let aspect = Aspect(id: \"\(aspect.id)\".uuid)"
                    + tab(6) + "aspect.name = \"\(aspect.name)\""
                        + tab(6) + "aspect.kind = .\(aspect.kind)"
                        + (aspect.exportCodedComputed ? (
                            tab(6) + "aspect.codedComputation = Aspect.Code." + "\(aspect.role!.name) \(aspect.name)".sourceCode
                                + tab(6) + "aspect.isComputed = true"
                        ) : "")
                        + tab(6) + "return aspect"
                        + tab(5) + "}()"
                }
                .joined(separator: ",")
                + tab(4) + "]"
        }
    }

    fileprivate var particlesSourceCode: String {
        if particles.isEmpty { "" } else {
            tab(2) + "role.particles = ["
                + particles.map { particle in
                    tab(3) + "{"
                        + tab(4) + "let particle = Particle(id: \"\(particle.id)\".uuid)"
                        + tab(4) + "particle.name = \"\(particle.name)\""
                        + particleAspectsSourceCode(particle: particle)
                        + tab(4) + "return particle"
                        + tab(3) + "}()"
                }
                .joined(separator: ",")
                + tab(2) + "]"
        }
    }

    fileprivate func representationsSourceCode(tab i: Int, document: Document) -> String {
        if representations.isEmpty { "" } else {
            tab(i) + "role.representations = ["
                + representations.map { representation in
                    tab(i + 1) + "{"
                        + tab(i + 2) + "let representation = Representation(id: \"\(representation.id)\".uuid)"
                        + tab(i + 2) + "representation.name = \"\(representation.name)\""
                        + tab(i + 2) + "representation.layouts = ["
                        + representation.layouts.map { ".\($0.description)" }.joined(separator: ",")
                        + "]"

                        + tab(i + 2) + "representation.presentation = " + representation.presentation.sourceCode(tab: 4, inline: true, document: document)
                        + tab(i + 2) + "return representation"
                        + tab(i + 1) + "}()"
                }
                .joined(separator: ",")
                + tab(i + 1) + "]"
        }
    }
}

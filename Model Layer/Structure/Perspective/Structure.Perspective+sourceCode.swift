//
//  Structure.Perspective+sourceCode.swift
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

extension Structure.Perspective: SourceCodeGenerator {
    func sourceCode(tab i: Int, inline _: Bool, document: Document) -> String {
        tab(i) + "static var \(name.sourceCode): Perspective {"
            + tab(i + 1) + "let perspective = Perspective(id: \"\(id)\".uuid)"
            + tab(i + 1) + "perspective.name = \"\(name)\""
            + perspectivesSourceCode(tab: i + 1)
            + referencesSourceCode(tab: i + 1)
            + aspectsSourceCode(tab: i + 1)
            + particlesSourceCode(tab: i + 1, document: document)
            + representationsSourceCode(tab: i + 1, document: document)
            + tab(i + 1) + "return perspective"
            + tab(i) + "}"
    }

    fileprivate func perspectivesSourceCode(tab i: Int) -> String {
        if perspectives.isEmpty { "" } else {
            tab(i) + "perspective.perspectives = ["
                + perspectives
                .map { "\($0.name.sourceCode)" }
                .joined(separator: ", ")
                + "]"
        }
    }

    fileprivate func referencesSourceCode(tab i: Int) -> String {
        if references.isEmpty { "" } else {
            tab(i) + "perspective.references = ["
                + references
                .map { "\($0.name.sourceCode)" }
                .joined(separator: ", ")
                + "]"
        }
    }

    fileprivate func aspectsSourceCode(tab i: Int) -> String {
        if aspects.isEmpty { "" } else {
            tab(i) + "perspective.aspects = ["
                + aspects.map { aspect in
                    tab(i + 1) + "{"
                        + tab(i + 2) + "let aspect = Aspect(id: \"\(aspect.id)\".uuid)"
                        + tab(i + 2) + "aspect.name = \"\(aspect.name)\""
                        + tab(i + 2) + "aspect.kind = .\(aspect.kind)"
//                        + (aspect.exportCodedComputed ? (
//                            tab(i + 2) + "aspect.codedComputation = Aspect.Code." + "\(aspect.perspective!.name) \(aspect.name)".sourceCode
//                                + tab(i + 2) + "aspect.isComputed = true"
//                        ) : "")
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
//                        + (aspect.exportCodedComputed ? (
//                            tab(6) + "aspect.codedComputation = Aspect.Code." + "\(aspect.perspective!.name) \(aspect.name)".sourceCode
//                                + tab(6) + "aspect.isComputed = true"
//                        ) : "")
                        + tab(6) + "return aspect"
                        + tab(5) + "}()"
                }
                .joined(separator: ",")
                + tab(4) + "]"
        }
    }

    fileprivate func particlesSourceCode(tab i: Int, document _: Document) -> String {
        if particles.isEmpty { "" } else {
            tab(i) + "perspective.particles = ["
                + particles.map { particle in
                    tab(i + 1) + "{"
                        + tab(i + 2) + "let particle = Particle(id: \"\(particle.id)\".uuid)"
                        + tab(i + 2) + "particle.name = \"\(particle.name)\""
                        + particleAspectsSourceCode(particle: particle)
                        + tab(i + 2) + "return particle"
                        + tab(i + 1) + "}()"
                }
                .joined(separator: ",")
                + tab(i) + "]"
        }
    }

    fileprivate func representationsSourceCode(tab i: Int, document: Document) -> String {
        if representations.isEmpty { "" } else {
            tab(i) + "perspective.representations = ["
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

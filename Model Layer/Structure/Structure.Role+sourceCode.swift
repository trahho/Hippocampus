//
//  Structure.Role+sourceCode.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.06.24.
//

import Foundation

extension Structure.Role {
    fileprivate var cr: String { "\n" }
    fileprivate var tab: (Int) -> String {
        { "\n" + String(repeating: "\t", count: $0) }
    }

    fileprivate var rolesSourceCode: String {
        if roles.isEmpty { "" } else {
            tab(2) + "role.roles = ["
                + roles
                .map { ".\($0.name)" }
                .joined(separator: ", ")
                + "]"
        }
    }

    fileprivate var referencesSourceCode: String {
        if references.isEmpty { "" } else {
            tab(2) + "role.references = ["
                + references
                .map { ".\($0.name)" }
                .joined(separator: ", ")
                + "]"
        }
    }

    fileprivate var aspectsSourceCode: String {
        if aspects.isEmpty { "" } else {
            tab(2) + "role.aspects = ["
                + aspects.map { aspect in
                    tab(3) + "{"
                        + tab(4) + "let aspect = Aspect(id: \"\(aspect.id)\".uuid)"
                        + tab(4) + "aspect.name = \"\(aspect.name)\""
                        + tab(4) + "aspect.kind = .\(aspect.kind)"
                        + tab(4) + "aspect.computed = \(aspect.computed)"
                        + tab(4) + "return aspect"
                        + tab(3) + "}()"
                }
                .joined(separator: ",")
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
                        + tab(6) + "aspect.computed = \(aspect.computed)"
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

    fileprivate func presentationItemSourceCode(presentation: Presentation, tab i: Int) -> String {
        switch presentation {
        case .empty:
            tab(i) + ".empty"
        case .undefined:
            tab(i) + ".undefined"
        case .label(let string):
            tab(i) + ".label(\"\(string)\")"
        case .aspect(let aspectId, let presentation):
            tab(i) + ".aspect(\"\(aspectId)\".uuid, presentation: .\(presentation))"
        case .grouped(let children):
            tab(i) + ".grouped(["
               /* + tab(i + 1)*/ + children.map { presentationItemSourceCode(presentation: $0, tab: i + 1) }.joined(separator: ", ")
                + tab(i) + "])"
        case .horizontal(let children, let alignment):
            tab(i) + ".horizontal(["
               /* + tab(i + 1)*/ + children.map { presentationItemSourceCode(presentation: $0, tab: i + 1) }.joined(separator: ", ")
                + tab(i) + "], alignment: .\(alignment))"
        case .vertical(let children, let alignment):
            tab(i) + ".vertical(["
              /*  + tab(i + 1) */+ children.map { presentationItemSourceCode(presentation: $0, tab: i + 1) }.joined(separator: ", ")
                + tab(i) + "], alignment: .\(alignment))"
        case .background(let children, let color):
            tab(i) + ".background(["
               /* + tab(i + 1)*/ + children.map { presentationItemSourceCode(presentation: $0, tab: i + 1) }.joined(separator: ", ")
                + tab(i) + "], color: Color(hex: \"\(color.toHex!)\"))"
        case .color(let children, let color):
            tab(i) + ".color(["
                /* + tab(i + 1) */ + children.map { presentationItemSourceCode(presentation: $0, tab: i + 1) }.joined(separator: ", ")
                + tab(i) + "], color: Color(hex: \"\(color.toHex!)\"))"
        default:
            ""
        }
    }

    fileprivate func presentationSourceCode(presentation: Presentation, tab i: Int, inline: Bool = false) -> String {
        if inline {
            presentationItemSourceCode(presentation: presentation, tab: i)
        } else {
            tab(i) + presentationItemSourceCode(presentation: presentation, tab: i)
        }
    }

    fileprivate var representationsSourceCode: String {
        if representations.isEmpty { "" } else {
            tab(2) + "role.representations = ["
                + representations.map { representation in
                    tab(3) + "{"
                        + tab(4) + "let representation = Representation(id: \"\(representation.id)\".uuid)"
                        + tab(4) + "representation.name = \"\(representation.name)\""
                        + tab(4) + "representation.presentation = " + presentationSourceCode(presentation: representation.presentation, tab: 4, inline: true)
                        + tab(4) + "return representation"
                        + tab(3) + "}()"
                }
                .joined(separator: ",")
                + tab(2) + "]"
        }
    }

    var sourceCode: String {
        tab(1) + "static let \(name): Role = {"
            + tab(2) + "var role = Role(id: \"\(id)\".uuid)"
            + tab(2) + "role.name = \"\(name)\""
            + rolesSourceCode
            + referencesSourceCode
            + aspectsSourceCode
            + particlesSourceCode
            + representationsSourceCode
            + tab(2) + "return role"
            + tab(1) + "}()" + cr
    }
}

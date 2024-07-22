//
//  Structure.Filter+sourceCode.swift
//  Hippocampus
//
//  Created by Guido Kühn on 10.07.24.
//

import Foundation

extension Structure.Filter: SourceCodeGenerator {
    func sourceCode(tab i: Int, inline _: Bool, document: Document) -> String {
        tab(i) + "static let \(name.sourceCode): Filter = {"
            + tab(i + 1) + "var filter = Filter(id: \"\(id)\".uuid)"
            + tab(i + 1) + "filter.name = \"\(name)\""
            + tab(i + 1) + "filter.layouts = [" + layouts.map { "." + $0.description }.joined(separator: ",") + "]"
            + tab(i + 1) + "filter.roles = [" + roles.map { "." + $0.name.sourceCode }.joined(separator: ", ") + "]"
            + superFiltersSourceCode(tab: i + 1)
            //            + referencesSourceCode
            //            + aspectsSourceCode
            //            + particlesSourceCode
            //            + representationsSourceCode
            + tab(i + 1) + "filter.condition = " + condition.sourceCode(tab: i + 2, inline: true, document: document)
            + representationsSourceCode(tab: i + 1, document: document)
            + tab(i + 1) + "return filter"
            + tab(i) + "}()" + cr
    }

    fileprivate func representationsSourceCode(tab i: Int, document: Document) -> String {
        if representations.isEmpty { "" } else {
            tab(i) + "filter.representations = ["
                + representations
                .map {
                    tab(i + 1) + "{"
                        + tab(i + 2) + "let representation = Representation()"
                        + tab(i + 2) + "representation.condition = " + $0.condition.sourceCode(tab: i + 3, inline: true, document: document)
                        + tab(i + 2) + "representation.presentation = " + $0.presentation.sourceCode(tab: i + 3, inline: true, document: document)
                        + tab(i + 2) + "return representation"
                        + tab(i + 1) + "}()"
                        + tab(i + 1) + "]"
                }
                .joined(separator: ",")
        }
    }

    fileprivate func superFiltersSourceCode(tab i: Int) -> String {
        if superFilters.isEmpty { "" } else {
            tab(i) + "filter.superFilters = ["
                + superFilters
                .map { ".\($0.name.sourceCode)" }
                .joined(separator: ", ")
                + "]"
        }
    }
//
//    fileprivate var referencesSourceCode: String {
//        if references.isEmpty { "" } else {
//            tab(2) + "role.references = ["
//                + references
//                .map { ".\($0.name)" }
//                .joined(separator: ", ")
//                + "]"
//        }
//    }
//
//    fileprivate var aspectsSourceCode: String {
//        if aspects.isEmpty { "" } else {
//            tab(2) + "role.aspects = ["
//                + aspects.map { aspect in
//                    tab(3) + "{"
//                        + tab(4) + "let aspect = Aspect(id: \"\(aspect.id)\".uuid)"
//                        + tab(4) + "aspect.name = \"\(aspect.name)\""
//                        + tab(4) + "aspect.kind = .\(aspect.kind)"
//                        + tab(4) + "aspect.computed = \(aspect.computed)"
//                        + tab(4) + "return aspect"
//                        + tab(3) + "}()"
//                }
//                .joined(separator: ",")
//            + tab(2) + "]"
//        }
//    }
//
//    fileprivate func particleAspectsSourceCode(particle: Particle) -> String {
//        if particle.aspects.isEmpty { "" } else {
//            tab(4) + "particle.aspects = ["
//                + particle.aspects.map { aspect in
//                    tab(5) + "{"
//                        + tab(6) + "let aspect = Aspect(id: \"\(aspect.id)\".uuid)"
//                        + tab(6) + "aspect.name = \"\(aspect.name)\""
//                        + tab(6) + "aspect.kind = .\(aspect.kind)"
//                        + tab(6) + "aspect.computed = \(aspect.computed)"
//                        + tab(6) + "return aspect"
//                        + tab(5) + "}()"
//                }
//                .joined(separator: ",")
//                + tab(4) + "]"
//        }
//    }
//
//    fileprivate var particlesSourceCode: String {
//        if particles.isEmpty { "" } else {
//            tab(2) + "role.particles = ["
//                + particles.map { particle in
//                    tab(3) + "{"
//                        + tab(4) + "let particle = Particle(id: \"\(particle.id)\".uuid)"
//                        + tab(4) + "particle.name = \"\(particle.name)\""
//                        + particleAspectsSourceCode(particle: particle)
//                        + tab(4) + "return particle"
//                        + tab(3) + "}()"
//                }
//                .joined(separator: ",")
//                + tab(2) + "]"
//        }
//    }
//
//
//    fileprivate var representationsSourceCode: String {
//        if representations.isEmpty { "" } else {
//            tab(2) + "role.representations = ["
//                + representations.map { representation in
//                    tab(3) + "{"
//                        + tab(4) + "let representation = Representation(id: \"\(representation.id)\".uuid)"
//                        + tab(4) + "representation.name = \"\(representation.name)\""
//                        + tab(4) + "representation.presentation = " + presentationSourceCode(presentation: representation.presentation, tab: 4, inline: true)
//                        + tab(4) + "return representation"
//                        + tab(3) + "}()"
//                }
//                .joined(separator: ",")
//                + tab(2) + "]"
//        }
//    }

//    func sourceCode(
//
//        tab(1) + "static let \(name): Filter = {"
//            + tab(2) + "var filter = Filter(id: \"\(id)\".uuid)"
//            + tab(2) + "filter.name = \"\(name)\""
//            + superFiltersSourceCode
    ////            + referencesSourceCode
    ////            + aspectsSourceCode
    ////            + particlesSourceCode
    ////            + representationsSourceCode
//            + tab(2) + "return filter"
//            + tab(1) + "}()" + cr
//    }
}

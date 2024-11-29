//
//  Information.Computation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.05.24.
//

import Foundation

extension Information {
    indirect enum Computation: PersistentValue, Hashable {
        case count(Condition)
        case minimum(Structure.Aspect.ID, Structure.Aspect.Kind.Form?, Condition)
        case maximum(Structure.Aspect.ID, Structure.Aspect.Kind.Form?, Condition)

        case system
        case constant(Information.ValueStorage)
        case value(Structure.Aspect.ID, form: Structure.Aspect.Kind.Form?)

        // MARK: Nested Types

        typealias Value = Structure.Aspect.Value

        // MARK: Functions

        // MARK: Internal

//        func getValues<T: Comparable>(aspect: Structure.Aspect.ID, condition: Condition, for items: Set<Item>) -> [T] {
//            items.filter { condition.matches($0) }.compactMap { $0[aspect]?.value as? T }
//        }

//        func matches(_ item: Aspectable, samePerspective: Structure.Perspective? = nil, structure: Structure) -> Bool {
//            var perspectives: [Structure.Perspective] = []
//            return matches(item, samePerspective: samePerspective, structure: structure, perspectives: &perspectives)
//        }
//
//        func matches(_ item: Aspectable, samePerspective: Structure.Perspective? = nil, structure: Structure, perspectives: inout [Structure.Perspective]) -> Bool {
//            if let item = item as? Item {
//                return itemMatches(item, samePerspective: samePerspective, structure: structure, perspectives: &perspectives)
//            } else if let particle = item as? Particle {
//                return particleMatches(particle, structure: structure, perspectives: &perspectives)
//            }
//        }

        func compute(for items: [Aspectable], structure: Structure) -> Value {
            switch self {
            case let .minimum(aspect, form, condition):
                guard let aspect = structure[Structure.Aspect.self, aspect] else { return Value() }
                return Value(items.filter { condition.matches($0, structure: structure) }.compactMap { aspect[$0, form].storage }.min())
            case let .maximum(aspect, form, condition):
                guard let aspect = structure[Structure.Aspect.self, aspect] else { return Value() }
                return Value(items.filter { condition.matches($0, structure: structure) }.compactMap { aspect[$0, form].storage }.max())
            case let .count(condition):
                return Value(ValueStorage(items.filter { condition.matches($0, structure: structure) }.count))
            case let .constant(value):
                return Value(value)
            case let .value(aspect, form):
                guard let item = items.first, let aspect = structure[Structure.Aspect.self, aspect] else { return Value() }
                return aspect[item, form]
            default:
                return Value()
            }
        }

        func compute(for item: Aspectable, structure: Structure) -> Value {
            compute(for: [item], structure: structure)
        }
    }
}

extension Information.Computation: SourceCodeGenerator {
    func sourceCode(tab i: Int, inline: Bool, document: Document) -> String {
        switch self {
        case let .minimum(aspect, form, condition):
            let formCode = form == nil ? "" : (form!.description + ", ")
            return ".minimum(\"\(aspect)\".uuid, " + formCode + condition.sourceCode(tab: i, inline: true, document: document) + ")"
        case let .maximum(aspect, form, condition):
            let formCode = form == nil ? "" : ("." + form!.description + ", ")
            return ".maximum(\"\(aspect)\".uuid, " + formCode + condition.sourceCode(tab: i, inline: true, document: document) + ")"
        case let .count(condition):
            return ".count(" + condition.sourceCode(tab: i, inline: true, document: document) + ")"
        case let .constant(value):
            return ".constant(" + value.sourceCode(tab: i, inline: true, document: document) + ")"
        case let .value(aspect, form):
             let formCode = form == nil ? "" : (", ." + form!.description)
             return ".value(\"\(aspect)\".uuid" + formCode + ")"
             default:
            return "not implemented"
        }
    }
}

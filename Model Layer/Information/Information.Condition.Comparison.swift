//
//  Information.Condition.Comparison.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.05.23.
//

import Foundation
import Smaug

extension Information.Condition {
    indirect enum Comparison: Information.PersistentValue, Hashable {
        case `nil`
        case below(ID, Form? = nil, Value)
        case above(ID, Form? = nil, Value)
        case equal(ID, Value, Form? = nil)
        case unequal(ID, Form? = nil, Value)
        case anyValue(ID)

        // MARK: Nested Types

        typealias Value = Information.Computation
        typealias ID = Structure.Aspect.ID
        typealias Form = Structure.Aspect.Kind.Form

        // MARK: Functions

        // MARK: Internal

        func appendPerspective(perspective: Structure.Perspective?, perspectives: inout [Structure.Perspective]) {
            guard let perspective, perspectives.firstIndex(of: perspective) == nil else { return }
            perspectives.append(perspective)
        }

        func matches(for item: Aspectable, structure: Structure, perspectives: inout [Structure.Perspective]) -> Bool {
            switch self {
            case .nil:
                return false
            case let .below(aspect, form, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item, form].storage else { return true }
                appendPerspective(perspective: aspect.perspective, perspectives: &perspectives)
                return itemValue < value.compute(for: [item], structure: structure).storage ?? .nil
            case let .above(aspect, form, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item, form].storage else { return false }
                appendPerspective(perspective: aspect.perspective, perspectives: &perspectives)
                return itemValue > value.compute(for: [item], structure: structure).storage ?? .nil
            case let .equal(aspect, value, form):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item, form].storage else { return false }
                appendPerspective(perspective: aspect.perspective, perspectives: &perspectives)
                return itemValue == value.compute(for: [item], structure: structure).storage ?? .nil
            case let .unequal(aspect, form, value):
                guard let aspect = structure[Structure.Aspect.self, aspect], let itemValue = aspect[item, form].storage else { return true }
                appendPerspective(perspective: aspect.perspective, perspectives: &perspectives)
                return itemValue != value.compute(for: [item], structure: structure).storage ?? .nil
            case let .anyValue(aspect):
                guard let aspect = structure[Structure.Aspect.self, aspect] else { return false }
                appendPerspective(perspective: aspect.perspective, perspectives: &perspectives)
                if aspect.isComputed {
                    return aspect[item, nil].isNil == false
                } else {
                    return item[aspect.id].isNil == false
                }
            }
        }
    }
}

extension Equatable {
    func isEqualTo(_ other: (any Equatable)?) -> Bool {
        if let other = other as? Self {
            if let other = other as? String, let `self` = self as? String {
                if other.hasPrefix("/"), other.hasSuffix("/"), let regex = try? Regex(String(other.dropFirst().dropLast())) {
                    return self.contains(regex)
                } else {
                    return self == other
                }
            } else {
                return true
            }
        } else {
            return false
        }
    }
}

func isEqual(_ a: (any Equatable)?, _ b: (any Equatable)?) -> Bool {
    if a == nil, b == nil { return true }
    else if let a, a.isEqualTo(b) { return true }
    else if let b, b.isEqualTo(a) { return true }
    else { return false }
}

extension Comparable {
    func isBelowOf(_ other: (any Equatable)?) -> Bool {
        if let other = other as? Self, self < other {
            return true
        } else {
            return false
        }
    }
}

func isBelow(_ a: (any Comparable)?, _ b: (any Comparable)?) -> Bool {
    if a == nil, b != nil { return true }
    if a != nil, b == nil { return false }
    else if let a, a.isBelowOf(b) { return true }
    else if let b, b.isBelowOf(a) || b.isEqualTo(a) { return false }
    else { return false }
}

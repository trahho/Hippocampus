//
//  PersistentGraph.Predicate.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.12.22.
//

import Foundation

infix operator ~>: AdditionPrecedence
infix operator <~: AdditionPrecedence

extension PersistentGraph {
    indirect enum Condition: PersistentValue {
        typealias PersistentComparableValue = PersistentValue & Comparable
        typealias Storage = PersistentGraph.ValueStorage

        struct Comparison: Serializable, Equatable {
            enum Relation: Int {
                case below, above, equal, unequal
            }

            static func == (lhs: Comparison, rhs: Comparison) -> Bool {
                lhs.key == rhs.key && lhs.condition == rhs.condition && isEqual(lhs.value, rhs.value)
            }

            @Serialized var key: Key
            @Serialized var storage: Storage
            @Serialized var condition: Relation

            var value: (any PersistentComparableValue)? {
                get {
                    return storage.value as? (any PersistentComparableValue)
                }
                set {
                    storage = Storage(newValue)
                }
            }

            init() {}

            init(key: Key, value: any PersistentComparableValue, condition: Relation) {
                self.key = key
                self.value = value
                self.condition = condition
            }

            func calculate(for item: Item) -> Bool {
                guard let timedValue = item.timedValue(for: key) else { return false }
                guard let value = timedValue.value as? (any Comparable) else { return false }
                switch condition {
                case .below:
                    return isBelow(value, self.value)
                case .above:
                    return !isEqual(value, self.value) && !isBelow(value, self.value)
                case .equal:
                    return isEqual(value, self.value)
                case .unequal:
                    return !isEqual(value, self.value)
                }
            }
        }

//        enum Comparison: Int {
//            case below, above, equal, unequal
//
//            func compare<T: Comparable>(_ a: T?, _ b: T?) -> Bool {
//                switch self {
//                case .below:
//                    return a != nil && (b == nil || a! < b!)
//                case .above:
//                    return b != nil && (a == nil || a! > b!)
//                case .equal:
//                    return a == b
//                case .unequal:
//                    return a != b
//                }
//            }
//        }

        case always(Bool)
        case hasRole(Role)
        case hasValue(Comparison)
        case not(Condition)
        case any([Condition])
        case all([Condition])

        func matches(for item: Item) -> Bool {
            switch self {
            case let .always(value):
                return value
            case let .hasRole(role):
                return item[role: role]
            case let .hasValue(comparison):
                return comparison.calculate(for: item)
            case let .not(condition):
                return !condition.matches(for: item)
            case let .any(conditions):
                for condition in conditions {
                    if condition.matches(for: item) {
                        return true
                    }
                }
                return false
            case let .all(conditions):
                for condition in conditions {
                    if !condition.matches(for: item) {
                        return false
                    }
                }
                return true
            }
        }
    }

//    static func ~> (lhs: Mind.Opinion, rhs: Mind.Opinion) -> Mind.Opinion {
//        lhs && AboutOne.Acquaintance(.knows, rhs)
//    }
//
//    static func <~ (lhs: Mind.Opinion, rhs: Mind.Opinion) -> Mind.Opinion {
//        AboutOne.Acquaintance(.known, rhs) && rhs
//    }

//    class Predicate: Serializable, Equatable {
//        static func == (lhs: Predicate, rhs: Predicate) -> Bool {
//            false
//        }
//
//        required init() {}
//
//        func matches(for member: Member) -> Bool {
//            false
//        }
//    }
}

// extension PersistentGraph.Predicate {
//    class Single: PersistentGraph.Predicate {
//        @Serialized var predicate: PersistentGraph.Predicate
//
//        required init() {}
//
//        init(_ predicate: PersistentGraph.Predicate) {
//            super.init()
//            self.predicate = predicate
//        }
//
//        class Not: Single {
//            static func == (lhs: Not, rhs: Not) -> Bool {
//                isEqual(lhs, rhs)
//            }
//
//            override func matches(for member: PersistentGraph.Member) -> Bool {
//                !predicate.matches(for: member)
//            }
//        }
//
//        class Acquaintance: Single {
//            enum Familiarity {
//                case knows, known, unknowing, unknown
//            }
//
//            @Serialized var familiarity: Familiarity
//
//            init(_ familiarity: Familiarity, _ opinion: Mind.Opinion) {
//                super.init(opinion)
//                self.familiarity = familiarity
//            }
//
//            required init() {
//                super.init()
//            }
//
//            override func take(for information: Brain.Information) -> (matches: Bool, perspectives: Set<Perspective>) {
//                if let synapse = information as? Brain.Synapse {
//                    switch familiarity {
//                    case .knows:
//                        let result = opinion.take(for: synapse.receptor)
//                        return (result.matches, result.matches ? result.perspectives : [])
//                    case .known:
//                        let result = opinion.take(for: synapse.emitter)
//                        return (result.matches, result.matches ? result.perspectives : [])
//                    case .unknowing:
//                        return (false, [])
//                    case .unknown:
//                        return (false, [])
//                    }
//                } else if let neuron = information as? Brain.Neuron {
//                    switch familiarity {
//                    case .knows:
//                        guard let result = neuron.axons.flatMap({ [opinion.take(for: $0.receptor), opinion.take(for: $0)] }).first(where: { $0.matches }) else { return (false, []) }
//                        return result
//                    case .known:
//                        guard let result = neuron.dendrites.flatMap({ [opinion.take(for: $0.emitter), opinion.take(for: $0)] }).first(where: { $0.matches }) else { return (false, []) }
//                        return result
//                    case .unknowing:
//                        return (neuron.axons.isEmpty, [])
//                    case .unknown:
//                        return (neuron.dendrites.isEmpty, [])
//                    }
//                } else {
//                    return (false, [])
//                }
//            }
//        }
//    }
// }

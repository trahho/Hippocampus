//
//  Brain.thought.swift
//  Hippocampus
//
//  Created by Guido Kühn on 08.08.22.
//

import Foundation

extension Mind {
    class Opinion: PersistentObject {
        typealias ComparableCodable = Codable & Comparable

        func take(for information: Brain.Information) -> (matches: Bool, perspectives: Set<Perspective>) {
            (false, [])
        }
    }
}

//        static func ~> (lhs: Thought, rhs: Thought) -> Thought {
//            lhs && .knows(rhs)
//        }
//
//        static func <~ (lhs: Thought, rhs: Thought) -> Thought {
//            .knownBy(lhs) && rhs
//        }

//        class AspectBelow<T>: Opinion {}
//    }
//
//    enum Value: Codable {
//        case number(Int)
//        case any
//    }
//
//    indirect enum Thought: Codable {
//        typealias ComparableCodable = Codable & Comparable
//        case always(Bool)
//        case untrue(Thought)
//        case any([Thought])
//        case all([Thought])
//        case knownBy(Thought)
//        case knows(Thought)
////        case hasAxon(Thought)
////        case hasDendrite(Thought)
//        case takeOpinion(when: Thought, of: Perspective.ID)
//        case hasPerspective(Perspective.ID)
//        case aspectIsEqual(Aspect.ID, Value)
//        case aspectIsBelow(Aspect.ID, Value)
//        case aspectIsAbove(Aspect.ID, Value)
//
////        func opinion(of neuron: Brain.Neuron) -> (matches: Bool, perspective: Perspective.ID?) {
////            switch self {
////            case let .about(_, neuronThought):
////                return neuronThought.opinion(of: neuron)
////            case let .always(truth):
////                return (truth, nil)
////            case let .opposite(thought):
////                let opinion = thought.opinion(of: neuron)
////                return (!opinion.matches, opinion.perspective)
////            case let .any(thoughts):
////                return thoughts.map { $0.opinion(of: neuron) }.first { $0.matches } ?? (false, nil)
////            case let .all(thoughts):
////                return thoughts.reduce((matches: false, perspective: nil)) { sum, thought in
////                    let opinion = thought.opinion(of: neuron)
////                    return (sum.matches && opinion.matches, sum.perspective ?? opinion.perspective)
////                }
////            case let .takeOpinion(thought, perspective):
////                return (thought.opinion(of: neuron).matches, perspective)
////            case let .hasPerspective(id):
////                return (neuron.perspectives.contains(id), nil)
////            case let .knownBy(thought):
////                return neuron.dendrites.map { thought.opinion(of: $0.pre) }.first { $0.matches } ?? (false, nil)
////            case let .knows(thought):
////                return neuron.dendrites.map { thought.opinion(of: $0.receptor) }.first { $0.matches } ?? (false, nil)
////            case let .hasAxon(thought):
////                return neuron.axons.map { thought.opinion(of: $0) }.first { $0.matches } ?? (false, nil)
////            case let .hasDendrite(thought):
////                return neuron.dendrites.map { thought.opinion(of: $0) }.first { $0.matches } ?? (false, nil)
////            case let .aspectIsEqual(id, value):
////                return (isEqual(neuron.aspects[id], value), nil)
////            case let .aspectIsBelow(id, value):
////                return (isBelow(neuron.aspects[id], value), nil)
////            case let .aspectIsAbove(id, value):
////                return (isAbove(neuron.aspects[id], value), nil)
////            }
////        }
//
////        func opinion(of information: AspectStorage) -> (matches: Bool, perspective: Set<Perspective.ID>) {
////            switch self {
////            case let .always(truth):
////                return (truth, [])
////            case let .untrue(thought):
////                let opinion = thought.opinion(of: information)
////                return (!opinion.matches, opinion.perspective)
////            case let .any(thoughts):
////                return thoughts.map { $0.opinion(of: information) }.first { $0.matches } ?? (false, [])
////            case let .all(thoughts):
////                return thoughts.reduce((matches: false, perspective: Set<Perspective.ID>())) { sum, thought in
////                    let opinion = thought.opinion(of: information)
////                    return (sum.matches && opinion.matches, sum.perspective.union(opinion.perspective))
////                }
////            case let .takeOpinion(thought, perspective):
////                let opinion = thought.opinion(of: information)
////                return (opinion.matches, opinion.matches ? [perspective] : [])
////            case let .hasPerspective(id):
////                return (information.takesPerspective(id), [])
////            case let .knownBy(thought):
////                return thought.opinion(of: information)
////            case let .knows(thought):
////                return thought.opinion(of: information)
////            //            case .hasAxon:
////            //                return (false, nil)
////            //            case .hasDendrite:
////            //                return (false, nil)
////            case let .aspectIsEqual(id, value):
////                let isEqual = Aspect.compareValues(lhs: information[id], rhs: value) == .equal
////                return (isEqual, [])
////            case let .aspectIsBelow(id, value):
////                let isBelow = Aspect.compareValues(lhs: information[id], rhs: value) == .smaller
////                return (isBelow, [])
////            case let .aspectIsAbove(id, value):
////                let isAbove = Aspect.compareValues(lhs: information[id], rhs: value) == .larger
////                return (isAbove, [])
////            }
////        }
//
//        static let dateFormatter: DateFormatter = {
//            let result = DateFormatter()
//            result.dateStyle = .full
//            result.timeStyle = .full
//            return result
//        }()
//
//        func isEqual(_ aspectValue: Codable?, _ value: String) -> Bool {
//            guard let aspectValue = aspectValue else { return false }
//            if let aspectValue = aspectValue as? String {
//                return aspectValue == value
//            } else if let aspectValue = aspectValue as? Int, let value = Int(value) {
//                return aspectValue == value
//            } else if let aspectValue = aspectValue as? Date, let value = Self.dateFormatter.date(from: value) {
//                return aspectValue == value
//            } else {
//                return false
//            }
//        }
//
//        func isBelow(_ aspectValue: Codable?, _ value: String) -> Bool {
//            guard let aspectValue = aspectValue else { return true }
//            if let aspectValue = aspectValue as? String {
//                return aspectValue < value
//            } else if let aspectValue = aspectValue as? Int, let value = Int(value) {
//                return aspectValue < value
//            } else if let aspectValue = aspectValue as? Date, let value = Self.dateFormatter.date(from: value) {
//                return aspectValue < value
//            } else {
//                return false
//            }
//        }
//
//        func isAbove(_ aspectValue: Codable?, _ value: String) -> Bool {
//            guard let aspectValue = aspectValue else { return false }
//            if let aspectValue = aspectValue as? String {
//                return aspectValue > value
//            } else if let aspectValue = aspectValue as? Int, let value = Int(value) {
//                return aspectValue > value
//            } else if let aspectValue = aspectValue as? Date, let value = Self.dateFormatter.date(from: value) {
//                return aspectValue > value
//            } else {
//                return false
//            }
//        }
//
//        static prefix func ! (rhs: Thought) -> Thought {
//            .untrue(rhs)
//        }
//
//        static func && (lhs: Thought, rhs: Thought) -> Thought {
//            if case let .all(thoughts) = lhs {
//                return .all(thoughts + [rhs])
//            } else if case let .all(thoughts) = rhs {
//                return .all([lhs] + thoughts)
//            } else {
//                return .all([lhs, rhs])
//            }
//        }
//
//        static func || (lhs: Thought, rhs: Thought) -> Thought {
//            if case let .any(thoughts) = lhs {
//                return .any(thoughts + [rhs])
//            } else if case let .any(thoughts) = rhs {
//                return .any([lhs] + thoughts)
//            } else {
//                return .any([lhs, rhs])
//            }
//        }
//
//        static func ~> (lhs: Thought, rhs: Thought) -> Thought {
//            lhs && .knows(rhs)
//        }
//
//        static func <~ (lhs: Thought, rhs: Thought) -> Thought {
//            .knownBy(lhs) && rhs
//        }
//    }
// }

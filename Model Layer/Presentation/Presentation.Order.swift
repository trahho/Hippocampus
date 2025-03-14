//
//  Presentation.Order.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.07.24.
//

import Grisu

extension Presentation {
    enum Order: Structure.PersistentValue, Hashable, EditableListItem {
        case sorted(Structure.Aspect.ID, ascending: Bool = true, form: Structure.Aspect.Kind.Form? = nil)
        case multiSorted([Order])

        // MARK: Computed Properties

        var id: String {
            switch self {
            case let .sorted(aspectId, ascending, form):
                return "\(aspectId)\(ascending)"
            case let .multiSorted(sorters):
                return "/\(sorters.map { $0.id }.joined(separator: "/"))"
            }
        }

        // MARK: Lifecycle

        init() {
            self = .sorted(.nil)
        }

        // MARK: Functions

        func description(structure _: Structure) -> String {
            switch self {
            case .sorted:
                return "sorted"
            case .multiSorted:
                return "mutiSorted"
            }
        }

        func textDescription(structure: Structure) -> String {
            switch self {
            case let .sorted(aspectId, ascending, form):
                return (structure[Structure.Aspect.self, aspectId]?.description ?? "<no aspect>") + (ascending ? " 􀄨" : " 􀄩")
            case let .multiSorted(sorters):
                return sorters.map { $0.textDescription(structure: structure) }.joined(separator: " ")
            }
        }

        func compare(lhs: Information.Item, rhs: Information.Item, structure: Structure) -> Bool {
            switch self {
            case let .sorted(aspect, ascending, form):
                guard let aspect = structure[Structure.Aspect.self, aspect] else { return false }
                if ascending {
                    return lhs[aspect, form].storage ?? .nil < rhs[aspect, form].storage ?? .nil
                } else {
                    return lhs[aspect, form].storage ?? .nil > rhs[aspect, form].storage ?? .nil
                }
            case let .multiSorted(sorters):
                for sorter in sorters {
                    if sorter.compare(lhs: lhs, rhs: rhs, structure: structure) { return true }
                    if sorter.compare(lhs: rhs, rhs: lhs, structure: structure) { return false }
                }
                return false
            }
        }
    }
}

extension Presentation.Order: SourceCodeGenerator {
    func sourceCode(tab i: Int, inline: Bool, document: Document) -> String {
        let start = inline ? "" : tab(i)
        switch self {
        case let .sorted(aspectId, ascending, form):
            let formCode = form == nil ? "" : (", form: ." + form!.description)
            return start + ".sorted(\"\(aspectId)\".uuid, ascending: \(ascending)\(formCode))"
        case let .multiSorted(sorters):
            return start + ".multiSorted([\(sorters.map { $0.sourceCode(tab: i + 1, inline: inline, document: document) }.joined(separator: ", "))])"
        }
    }
}

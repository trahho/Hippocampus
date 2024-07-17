//
//  Presentation.Order.swift
//  Hippocampus
//
//  Created by Guido Kühn on 16.07.24.
//

extension Presentation {
    enum Order: Structure.PersistentValue, Hashable {
        case sorted(Structure.Aspect.ID, ascending: Bool = true)
        case multiSorted([Order])

        // MARK: Functions

        func description(structure: Structure) -> String {
            switch self {
            case let .sorted(aspect, ascending):
                let name = structure[Structure.Aspect.self, aspect]?.description ?? "Unknown"
                return "\(name) \(ascending ? "Ascending" : "Descending")"
            case let .multiSorted(sorters):
                return sorters.map { $0.description(structure: structure) }.joined(separator: ", ")
            }
        }

        func compare(lhs: Information.Item, rhs: Information.Item, structure: Structure) -> Bool {
            switch self {
            case let .sorted(aspect, ascending):
                guard let aspect = structure[Structure.Aspect.self, aspect] else { return false }
                if ascending {
                    return lhs[aspect] ?? .nil < rhs[aspect] ?? .nil
                } else {
                    return lhs[aspect] ?? .nil > rhs[aspect] ?? .nil
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

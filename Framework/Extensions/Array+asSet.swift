//
//  Array+asSet.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.05.22.
//

import Foundation

extension Array where Element: Hashable {
    var asSet: Set<Element> {
        Set(self)
    }

    func asDictionary<Key: Hashable>(key: KeyPath<Self.Element, Key>) -> [Key: Self.Element] {
        reduce(into: [:]) { dictionary, element in
            dictionary[element[keyPath: key]] = element
        }
    }
}

extension Array where Element: Equatable {
    mutating func remove(item: Element) {
        guard let index = firstIndex(of: item) else { return }
        remove(at: index)
    }

    mutating func insert(item: Element, after: Element) {
        guard let index = firstIndex(of: after) else { return }
        insert(item, at: index + 1)
    }
}

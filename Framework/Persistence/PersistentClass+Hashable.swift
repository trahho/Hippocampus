//
//  PersistentClass+Hashable.swift
//  Hippocampus
//
//  Created by Guido Kühn on 04.12.22.
//

import Foundation

extension PersistentClass: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(typeName)
    }
}

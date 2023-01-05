//
//  Genes.swift
//  Hippocampus
//
//  Created by Guido Kühn on 29.09.22.
//

import Foundation
import SwiftUI


extension Genes {
    struct NotFoundError: Error {}
}

@dynamicMemberLookup
class Genes: PersistentObject, ObservableObject {
    @PublishedSerialized var dna: DNA = .init()
    @Serialized var ancestor: Genes?

    func getValue<T>(dynamicMember keyPath: WritableKeyPath<DNA, T?>) throws -> T? where T: Codable {
        if let value = dna[keyPath: keyPath] {
            return value
        } else if let ancestor, let value = try? ancestor.getValue(dynamicMember: keyPath) {
            return value
        } else if let value = DNA.origin[keyPath: keyPath] {
            return value
        }
        throw NotFoundError()
    }

    subscript<T>(dynamicMember keyPath: WritableKeyPath<DNA, T?>) -> T where T: Codable {
        get { try! getValue(dynamicMember: keyPath)! }
        set { dna[keyPath: keyPath] = newValue }
    }
}

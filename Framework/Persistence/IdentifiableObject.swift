//
//  IdentifiableObject.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 02.12.22.
//

import Foundation

open class IdentifiableObject: Identifiable, Hashable {
    public typealias ID = Int64

    @Serialized public var id: ID = 0

    public static func == (lhs: IdentifiableObject, rhs: IdentifiableObject) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

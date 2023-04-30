//
//  IdentifiableObject.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 02.12.22.
//

import Foundation

open class IdentifiableObject: Identifiable, Hashable {
//    public typealias ID = UUID
    public typealias ID = UUID

    @Serialized public var id: ID = UUID()

    public static func == (lhs: IdentifiableObject, rhs: IdentifiableObject) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension UUID {
    var key: String {
        String(utf16CodeUnits: [
            UInt16(uuid.0 << 8 + uuid.1),
            UInt16(uuid.2 << 8 + uuid.3),
            UInt16(uuid.4 << 8 + uuid.5),
            UInt16(uuid.6 << 8 + uuid.7),
            UInt16(uuid.8 << 8 + uuid.9),
            UInt16(uuid.10 << 8 + uuid.11),
            UInt16(uuid.12 << 8 + uuid.13),
            UInt16(uuid.14 << 8 + uuid.15)
        ], count: 8)
    }
}

//
//  PersistentObject.swift
//  Hippocampus
//
//  Created by Guido Kühn on 09.08.22.
//

import Combine
import Foundation

class PersistentObject: Serializable, ObservableObject, Hashable, Identifiable {
    typealias ID = Int64

    @Serialized var id: ID = 0

    static func == (lhs: PersistentObject, rhs: PersistentObject) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    required init() {}
}

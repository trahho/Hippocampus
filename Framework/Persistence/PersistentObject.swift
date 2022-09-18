//
//  PersistentObject.swift
//  Hippocampus
//
//  Created by Guido Kühn on 09.08.22.
//

import Combine
import Foundation

class IdentifiableObject: Identifiable, Hashable {
    typealias ID = Int64

    @Serialized var id: ID = 0

    static func == (lhs: IdentifiableObject, rhs: IdentifiableObject) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class PersistentObject: IdentifiableObject, Serializable {
    required override init(){
        super.init()
    }
}

//
//  IdentifiableObject.swift
//  Hippocampus
//
//  Created by Guido Kühn on 04.08.22.
//

import Foundation
protocol IdentifiableObject: AnyObject, Hashable, Identifiable {}
extension IdentifiableObject {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

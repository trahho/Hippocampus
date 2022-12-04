//
//  PersistentClass+Equatable.swift
//  Hippocampus
//
//  Created by Guido Kühn on 04.12.22.
//

import Foundation

extension PersistentClass: Equatable {
    public static func == (lhs: PersistentClass, rhs: PersistentClass) -> Bool {
        lhs.id == rhs.id && type(of: lhs) == type(of: rhs)
    }
}

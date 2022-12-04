//
//  Object+Equatable.swift
//  Hippocampus
//
//  Created by Guido Kühn on 04.12.22.
//

import Foundation

extension PersistentData.Object: Equatable {
    public static func == (lhs: PersistentData.Object, rhs: PersistentData.Object) -> Bool {
        lhs.id == rhs.id && type(of: lhs) == type(of: rhs)
    }
}

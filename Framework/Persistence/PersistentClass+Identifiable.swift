//
//  PersistentClass+Identifiable.swift
//  Hippocampus
//
//  Created by Guido Kühn on 04.12.22.
//

import Foundation

extension PersistentClass: Identifiable {
    public var id: PersistentData.Node.ID {
        node.id
    }
}

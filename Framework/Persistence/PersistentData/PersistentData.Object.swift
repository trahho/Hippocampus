//
//  PersistentClass.swift
//  Hippocampus
//
//  Created by Guido Kühn on 03.12.22.
//

import Combine
import Foundation

extension PersistentData {
    open class Object: PersistentData.Node {
        public required init() {}

        override func merge(other: PersistentData.Item) {
            guard let other = other as? Self else { return }
            super.merge(other: other)
            mergeValues(other: other)
        }

        func mergeValues(other _: Object) {}
    }
}

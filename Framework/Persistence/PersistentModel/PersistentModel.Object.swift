//
//  PersistentClass.swift
//  Hippocampus
//
//  Created by Guido Kühn on 03.12.22.
//

import Combine
import Foundation

extension PersistentModel {
    open class Object: PersistentModel.Node {
        public required init() {}

        override func merge(other: PersistentModel.Item) {
            guard let other = other as? Self else { return }
            super.merge(other: other)
            mergeValues(other: other)
        }

        func mergeValues(other _: Object) {}
    }
}

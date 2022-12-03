//
//  PersistentClass.swift
//  Hippocampus
//
//  Created by Guido Kühn on 03.12.22.
//

import Combine
import Foundation


open class PersistentClass: PersistentData.Node {
    required public init() {
        super.init()
        let typeName = String(describing: type(of: self))
        self[role: typeName] = true
    }
}

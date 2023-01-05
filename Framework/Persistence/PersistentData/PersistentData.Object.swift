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
        
        required public init() {
            super.init()
            let mirror = Mirror(reflecting: self)
        }
        
    }
}

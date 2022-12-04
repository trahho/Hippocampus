//
//  PersistentClass.swift
//  Hippocampus
//
//  Created by Guido Kühn on 03.12.22.
//

import Combine
import Foundation

open class PersistentClass: ObservableObject {
    internal let node: PersistentData.Node
    private var cancellable: AnyCancellable?

    internal var typeName: String{
        String(describing: type(of: self))
    }
    
    public init(_ node: PersistentData.Node) {
        self.node = node
        node[role: typeName] = true
        cancellable = node.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    public convenience init() {
        self.init(PersistentData.Node())
    }

    internal subscript(_ key: String) -> PersistentData.PersistentValue {
        get {
            node[key]
        }
        set {
            node[key] = newValue
        }
    }
}




//
//  PersistentClass.swift
//  Hippocampus
//
//  Created by Guido Kühn on 03.12.22.
//

import Combine
import Foundation

open class PersistentClass: ObservableObject {
    private let node: PersistentData.Node
    private var cancellables: Set<AnyCancellable> = []

    private var typeName: String{
        String(describing: type(of: self))
    }
    
    public init(_ node: PersistentData.Node) {
        self.node = node
        node[role: typeName] = true
        node.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
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

extension PersistentClass: Identifiable {
    public var id: PersistentData.Node.ID {
        node.id
    }
}

extension PersistentClass: Equatable {
    public static func == (lhs: PersistentClass, rhs: PersistentClass) -> Bool {
        lhs.id == rhs.id && type(of: lhs) == type(of: rhs)
    }
}

extension PersistentClass: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(typeName)
    }
}

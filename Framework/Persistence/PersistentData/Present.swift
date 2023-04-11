//
//  Present.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.12.22.
//

import Foundation

extension PersistentData {
    @propertyWrapper final class Present<Target> where Target: PersistentData.Object {
        typealias TargetSet = Set<Target>

        @available(*, unavailable, message: "This property wrapper can only be applied to classes")
        public var wrappedValue: TargetSet {
            get { fatalError() }
            set { fatalError() }
        }

        var condition: PersistentData.Condition

        //    var include: KeyPath<PersistentData, Set<Value>>?
        //
        //    init(include: KeyPath<PersistentData, Set<Value>>? = nil) {
        //        self.include = include
        //    }

        init(_ condition: PersistentData.Condition = .always(true)) {
            self.condition = condition
        }

        public static subscript<Enclosing: PersistentData>(_enclosingInstance instance: Enclosing,
                                                           wrapped _: ReferenceWritableKeyPath<Enclosing, TargetSet>,
                                                           storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Present>) -> TargetSet
        {
            get {
                let storage = instance[keyPath: storageKeyPath]
                return instance.nodes
                    .compactMap { $0 as? Target }
                    .filter { storage.condition.matches(for: $0) }
                    .asSet
            }
            set {}
        }
    }
}

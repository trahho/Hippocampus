//
//  Value.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.07.24.
//

extension Structure.Aspect {
    struct Value /*: Equatable & Comparable & Hashable */ {
        // MARK: Static Computed Properties

        static var `nil`: Value {
            Value()
        }

        // MARK: Properties

        let storage: Information.ValueStorage?
        let drawing: Document.Drawing.Content?

        // MARK: Computed Properties

        var value: (any Information.ValueStorage.PersistentValue)? {
            storage?.value
        }

        var isNil: Bool {
            storage == nil && drawing == nil
        }

        // MARK: Lifecycle

        init(_ valueStorage: Information.ValueStorage?) {
            drawing = nil
            storage = valueStorage
        }

        init(_ value: (any Information.Value)?) {
            drawing = nil
            storage = Information.ValueStorage(value)
        }

        init(_ drawing: Document.Drawing.Content?) {
            self.drawing = drawing
            storage = nil
        }

        init() {
            storage = nil
            drawing = nil
        }

        // MARK: Functions

//        func `as`<T>(_: T.Type) -> T? {
//            if let valueStorage {
//                return valueStorage.value as? T
//            } else if let drawing {
//                return drawing as? T
//            } else {
//                return nil
//            }
//        }
    }
}

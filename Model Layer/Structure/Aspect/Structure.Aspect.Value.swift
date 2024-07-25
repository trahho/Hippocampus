//
//  Value.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.07.24.
//

extension Structure.Aspect {
    struct Value/*: Equatable & Comparable & Hashable*/ {
        // MARK: Properties

        let valueStorage: Information.ValueStorage?
        let drawing: Document.Drawing?

        // MARK: Lifecycle

        init(_ valueStorage: Information.ValueStorage?) {
            drawing = nil
            self.valueStorage = valueStorage
        }

        init(_ value: (any Information.Value)?) {
            drawing = nil
            valueStorage = Information.ValueStorage(value)
        }

        init(_ drawing: Document.Drawing?) {
            self.drawing = drawing
            valueStorage = nil
        }

       

        // MARK: Functions

        func `as`<T>(_: T.Type) -> T? {
            if let valueStorage {
                return valueStorage.value as? T
            } else if let drawing {
                return drawing as? T
            } else {
                return nil
            }
        }
    }
}

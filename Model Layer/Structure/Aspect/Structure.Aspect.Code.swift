//
//  Code.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.07.24.
//

import Foundation

typealias CodedComputation = (get: (Aspectable, Structure.Aspect) -> (Structure.Aspect.Value), set: ((Aspectable, Structure.Aspect.Value, Structure.Aspect) -> Void)?)

enum Code {
    // MARK: Nested Types

    typealias Code = CodedComputation
    typealias ValueStorage = Information.ValueStorage
    typealias Value = Structure.Aspect.Value

    // MARK: Static Properties

    static let namedText: Code = (get: { _, _ in Value("Oha") }, set: nil)

    static let drawing: Code = (
        get: { item, aspect in
            guard let id = item[aspect.id].value as? String else {
                return Value()
            }
            let cache = aspect[Document.Drawing.self, id]
            return Value(cache.content)
        },
        set: { item, newValue, aspect in
            guard let newValue = newValue.drawing else { return }
            if let id = item[aspect.id].value as? String {
                aspect[Document.Drawing.self, id].content = newValue
            } else {
                let id = UUID().uuidString
                aspect[Document.Drawing.self, id].content = newValue
                item[aspect.id] = Value(id)
            }
        }
    )
}

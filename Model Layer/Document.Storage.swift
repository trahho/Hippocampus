//
//  Information.Storage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.04.23.
//

import Foundation
import Smaug

extension Document {
    indirect enum Storage: TimedValueStorage {
        case v(ValueStorage)
        case a(Structure.Presentation)
        case b(Structure.Aspect.Presentation)
        case c(Information.Condition)

        init(_ value: (any PersistentValue)?) {
            if let basicValue = ValueStorage(value) { self = .v(basicValue) }

            else if let value = value as? Structure.Presentation { self = .a(value) }
            else if let value = value as? Structure.Aspect.Presentation { self = .b(value) }
            else if let value = value as? Information.Condition { self = .c(value) }

            else { fatalError("Storage for \(value.self ?? "Hä?") not available") }
        }

        var value: (any PersistentValue)? {
            switch self {
            case let .v(value): return value.value
            case let .a(value): return value
            case let .b(value): return value
            case let .c(value): return value
            }
        }
    }
}

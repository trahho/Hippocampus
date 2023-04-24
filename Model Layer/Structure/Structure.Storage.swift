//
//  Structure.Storage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 11.04.23.
//

import Foundation
extension Structure {
    indirect enum Storage: TimedValueStorage {
        case v(ValueStorage)
        case presentation(Structure.Presentation)
        case aspectPresentation(Structure.Aspect.Presentation)

        init(_ value: (any PersistentValue)?) {
            if let basicValue = ValueStorage(value) { self = .v(basicValue) }

            else if let presentation = value as? Structure.Presentation { self = .presentation(presentation) }
            else if let aspectPresentation = value as? Structure.Aspect.Presentation { self = .aspectPresentation(aspectPresentation) }

            else { fatalError("Storage for \(value?.typeName ?? "Hä?") not available") }
        }

        var value: (any PersistentValue)? {
            switch self {
            case let .v(value): return value.value
            case let .presentation(value): return value
            case let .aspectPresentation(value): return value
            }
        }
    }
}

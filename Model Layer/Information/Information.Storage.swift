//
//  Information.Storage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.04.23.
//

import Foundation
import Smaug

extension Information {
    indirect enum Storage: TimedValueStorage {
        case v(ValueStorage)

        init(_ value: (any PersistentValue)?) {
            if let basicValue = ValueStorage(value) { self = .v(basicValue) }

            else { fatalError("Storage for \(value.self ?? "Hä?") not available") }
        }

        var value: (any PersistentValue)? {
            switch self {
            case let .v(value): return value.value
            }
        }
    }
}

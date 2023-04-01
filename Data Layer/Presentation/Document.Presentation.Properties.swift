//
//  Document.Presentation.Properties.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.03.23.
//

import Combine
import Foundation

extension Document.Presentation {
    class Property<T: Codable>: PersistentObject, ObservableObject {
        @PublishedSerialized private var modes: Set<Mode> = []
        @PublishedSerialized var value: T?

        subscript(mode: Mode) -> Bool {
            get {
                modes.isEmpty || modes.contains(mode)
            }
            set {
                if newValue {
                    modes.insert(mode)
                } else {
                    modes.remove(mode)
                }
            }
        }
    }

    enum Mode: Codable {
        case list, tree, map
    }

    class Properties: PersistentContent, Serializable, ObservableObject {
        @PublishedSerialized(notifiyChange: true) var globalValues: [Information.Item.ID: AnyObject] = [:]

        // MARK: - Publishers

        var objectDidChange = PassthroughSubject<Void, Never>()

        // MARK: - Initialisation

        public required init() {}

        // MARK: - Merging

        func merge(other: Properties) throws {}

        func restore() {}
    }
}

//
//  AspectStorage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 04.09.22.
//

import Combine
import Foundation

protocol AspectStorage: ObservableObject {
    func takesPerspective(_ id: Perspective.ID) -> Bool
    func takePerspective(_ id: Perspective.ID)

    subscript(_ id: Aspect.ID) -> Codable? {
        get set
    }

//    func setValue(_ key: Aspect.ID, value: Codable?)
}

extension AspectStorage {
    func takesPerspective(_ perspective: Perspective) -> Bool {
        takesPerspective(perspective.id)
    }

    func takePerspective(_ perspective: Perspective) {
        if let publisher = objectWillChange as? Combine.ObservableObjectPublisher {
            publisher.send()
        }
        takePerspective(perspective.id)
    }

    subscript(_ aspect: Aspect) -> Codable? {
        get { self[aspect.id] }
        set {
            if let publisher = objectWillChange as? Combine.ObservableObjectPublisher {
                publisher.send()
            }
            self[aspect.id] = newValue
            takePerspective(aspect.perspective)
        }
    }
}

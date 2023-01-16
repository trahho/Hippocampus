//
//  AspectStorage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 04.09.22.
//

import Combine
import Foundation

protocol AspectStorage: ObservableObject, Identifiable {
    func takesPerspective(_ id: Perspective.ID) -> Bool
    func takePerspective(_ id: Perspective.ID)

    subscript(_: Aspect.ID) -> Aspect.Point {
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

    subscript(_ aspect: Aspect) -> Aspect.Point {
        get { aspect[self] }
        set {
            if let publisher = objectWillChange as? Combine.ObservableObjectPublisher {
                publisher.send()
            }
            aspect[self] = newValue
            takePerspective(aspect.perspective)
        }
    }

    subscript(_ aspect: Aspect) -> String? {
        get {
            guard case let .string(string) = self[aspect] else {
                return nil
            }
            return string
        }
        set {
            if let newValue {
                self[aspect] = .string(newValue)
            } else {
                self[aspect] = .empty
            }
        }
    }

    subscript(_ aspect: Aspect) -> Date? {
        get {
            guard case let .date(date) = self[aspect] else {
                return nil
            }
            return date
        }
        set {
            if let newValue {
                self[aspect] = .date(newValue)
            } else {
                self[aspect] = .empty
            }
        }
    }
}

//
//  AspectStorage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 04.09.22.
//

import Foundation

protocol AspectStorage: AnyObject {
    func takesPerspective(_ id: Perspective.ID) -> Bool

    subscript(_ id: Aspect.ID) -> Codable? {
        get set
    }

//    func setValue(_ key: Aspect.ID, value: Codable?)
}

extension AspectStorage {
    func takesPerspective(_ perspective: Perspective) -> Bool {
        takesPerspective(perspective.id)
    }

    subscript(_ aspect: Aspect) -> Codable? {
        get { self[aspect.id] }
        set { self[aspect.id] = newValue }
    }
}

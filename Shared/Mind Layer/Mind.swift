//
//  Mind.swift
//  Hippocampus
//
//  Created by Guido Kühn on 08.08.22.
//

import Combine
import Foundation

final class Mind: Serializable, ObservableObject {
    var cancellable: AnyCancellable?
    private var _brain: Brain? {
        willSet {
            objectWillChange.send()
        }
        didSet {
            cancellable = _brain?.objectWillChange.sink(receiveValue: {
                self.objectWillChange.send()
            })
        }
    }

    var brain: Brain {
        _brain!
    }

    var isEmpty: Bool {
        _brain == nil
    }

    func adoptBrain(_ brain: Brain) {
        _brain = brain
    }
}

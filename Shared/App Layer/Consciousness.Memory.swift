//
//  Area.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.22.
//

import Combine
import Foundation

extension Consciousness {
    class Memory: Serializable, ObservableObject {

        @ObservedSerialized var brain: Brain = .init()

        required init() {}
    }
}

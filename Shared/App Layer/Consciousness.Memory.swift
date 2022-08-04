//
//  Area.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.22.
//

import Combine
import Foundation

extension Consciousness {
    class Memory: Serializable {
        var cancellables: Set<AnyCancellable> = []

        @Serialized var brain: Brain = .init() {
            willSet {
                objectWillChange.send()
            }
            didSet {
                brain.objectWillChange.sink(receiveValue: {
                    self.objectWillChange.send()
                })
                .store(in: &cancellables)
            }
        }

        required init() {}
    }
}

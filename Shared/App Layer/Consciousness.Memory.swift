//
//  Area.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.07.22.
//

import Combine
import Foundation

extension Consciousness {
    class Memory: ObservableObject {
        private var cancellables: Set<AnyCancellable> = []

//        private var persistentMemory: PersistentData<Memory>? {
//            willSet {
//                objectWillChange.send()
//            }
//            didSet {
//                persistentMemory?.objectWillChange.sink(receiveValue: {
//                    self.objectWillChange.send()
//                })
//                .store(in: &cancellables)
//            }
//        }
//
//        var memory: Memory {
//            persistentMemory!.content
//        }

        private var persistentBrain: PersistentData<Brain>?

        var brain: Brain {
            persistentBrain!.content
        }

        func commit() {
            if persistentBrain?.hasChanges ?? false {
                persistentBrain?.commit()
            }
        }

        private func brainUrl(url: URL) -> URL {
            url.appendingPathComponent("brain." + HippocampusApp.persistentExtension)
        }

        func setupBrain(url: URL) {
            persistentBrain = PersistentData<Brain>(url: brainUrl(url: url), content: Brain())
            persistentBrain?.objectWillChange.sink(receiveValue: {
                self.objectWillChange.send()
            })
            .store(in: &cancellables)
        }

        init(url: URL) {
            setupBrain(url: url)
        }
    }
}

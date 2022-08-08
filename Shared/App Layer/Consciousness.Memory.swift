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

        private var persistentBrain: PersistentData<Brain>?

        var brain: Brain {
            persistentBrain!.content
        }

        private var persistentMind: PersistentData<Mind>?

        var mind: Mind {
            persistentMind!.content
        }

        func commit() {
            if persistentBrain?.hasChanges ?? false {
                persistentBrain!.commit()
            }
            if persistentMind?.hasChanges ?? false {
                persistentMind!.commit()
            }
        }

        func setup<T>(url: URL, content: T, didRefresh: @escaping () -> ()) -> PersistentData<T> {
            let persistentT = PersistentData<T>(url: url, content: content)
            persistentT.didRefresh = didRefresh
            persistentT.objectWillChange.sink(receiveValue: {
                self.objectWillChange.send()
            })
            .store(in: &cancellables)
            return persistentT
        }

        func setupBrain(url: URL) {
            let brainUrl = url.appendingPathComponent("brain." + HippocampusApp.persistentExtension)
            persistentBrain = setup(url: brainUrl, content: Brain(), didRefresh: brainDidRefresh)
        }

        func setupMind(url: URL) {
            let mindUrl = url.appendingPathComponent("mind." + HippocampusApp.persistentExtension)
            persistentMind = setup(url: mindUrl, content: Mind(), didRefresh: mindDidRefresh)
        }

        func brainDidRefresh() {
            brain.recover()
            if let mind = persistentMind?.content {
                mind.adoptBrain(brain)
            }
        }

        func mindDidRefresh() {
            if let brain = persistentBrain?.content {
                mind.adoptBrain(brain)
            }
        }

        init(url: URL) {
            setupBrain(url: url)
            setupMind(url: url)
        }
    }
}

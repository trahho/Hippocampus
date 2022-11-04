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
        
        private var persistentImagination: PersistentData<Imagination>?

        var imagination: Imagination {
            persistentImagination!.content
        }

        func commit() {
            if persistentBrain?.hasChanges ?? false {
                persistentBrain!.commit()
            }
            if persistentMind?.hasChanges ?? false {
                persistentMind!.commit()
            }
            if persistentImagination?.hasChanges ?? false {
                persistentImagination!.commit()
            }
        }
        
        func commitBrain() {
            if persistentBrain?.hasChanges ?? false {
                persistentBrain!.commit()
            }
        }

        func setup<T>(url: URL, content: T, didRefresh: @escaping () -> Void) -> PersistentData<T> {
            let persistentData = PersistentData<T>(url: url, content: content)
            persistentData.didRefresh = didRefresh
            persistentData.content.objectWillChange.sink(receiveValue: {_ in 
                self.objectWillChange.send()
            })
            .store(in: &cancellables)
            return persistentData
        }

        func setupBrain(url: URL) {
            let brainUrl = url.appendingPathComponent("brain." + HippocampusApp.persistentExtension)
            persistentBrain = setup(url: brainUrl, content: Brain(), didRefresh: brainDidRefresh)
        }

        func setupMind(url: URL) {
            let mindUrl = url.appendingPathComponent("mind." + HippocampusApp.persistentExtension)
            persistentMind = setup(url: mindUrl, content: Mind(), didRefresh: mindDidRefresh)
        }
        
        func setupSenses(url: URL) {
            let sensesUrl = url.appendingPathComponent("senses." + HippocampusApp.persistentExtension)
            persistentImagination = setup(url: sensesUrl, content: Imagination(), didRefresh: sensesDidRefresh)
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
            if let senses = persistentImagination?.content {
                senses.adoptMind(mind)
            }
        }
        
        func sensesDidRefresh() {
            if let mind = persistentMind?.content {
                imagination.adoptMind(mind)
            }
        }

        init(url: URL) {
            setupBrain(url: url)
            setupMind(url: url)
        }
    }
}

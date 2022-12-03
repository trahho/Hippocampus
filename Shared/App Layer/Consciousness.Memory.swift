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

        private var persistentBrain: PersistentContainer<Brain>?

        var brain: Brain {
            persistentBrain!.content
        }

        private var persistentMind: PersistentContainer<Mind>?

        var mind: Mind {
            persistentMind!.content
        }
        
        private var persistentImagination: PersistentContainer<Imagination>?

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
        
//        func commitBrain() {
//            if persistentBrain?.hasChanges ?? false {
//                persistentBrain!.commit()
//            }
//        }

        func setup<T: PersistentContent>(url: URL, content: T, didRefresh: @escaping () -> Void) -> PersistentContainer<T> {
            let persistentData = PersistentContainer<T>(url: url, content: content)
            persistentData.didRefresh = didRefresh
            persistentData.objectWillChange.sink(receiveValue: {_ in 
                self.objectWillChange.send()
            })
            .store(in: &cancellables)
            return persistentData
        }

        func setupBrain(url: URL) {
            let brainUrl = url.appendingPathComponent("brain." + HippocampusApp.persistentExtension)
            persistentBrain = setup(url: brainUrl, content: Brain(), didRefresh: brainDidRefresh)
            persistentBrain!.commitOnChange = true
            brainDidRefresh()
//            persistentBrain!.refresh()
        }

        func setupMind(url: URL) {
            let mindUrl = url.appendingPathComponent("mind." + HippocampusApp.persistentExtension)
            persistentMind = setup(url: mindUrl, content: Mind(), didRefresh: mindDidRefresh)
//            persistentMind!.refresh()
        }
        
        func setupImagination(url: URL) {
            let imaginationUrl = url.appendingPathComponent("imagination." + HippocampusApp.persistentExtension)
            persistentImagination = setup(url: imaginationUrl, content: Imagination(), didRefresh: imaginationDidRefresh)
//            persistentImagination!.refresh()
        }

        func brainDidRefresh() {
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
        
        func imaginationDidRefresh() {
            if let mind = persistentMind?.content {
                imagination.adoptMind(mind)
            }
        }

        init(url: URL) {
            setupBrain(url: url)
            setupMind(url: url)
            setupImagination(url: url)
        }
    }
}

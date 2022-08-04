//
//  Consciousness.swift
//  Hippocampus
//
//  Created by Guido Kühn on 31.07.22.
//

import Combine
import Foundation

class Consciousness: ObservableObject {
    private var cancellable: AnyCancellable?

    private var persistentMemory: PersistentData<Memory>?{
        willSet {
            objectWillChange.send()
        }
        didSet {
            cancellable = persistentMemory?.objectWillChange.sink(receiveValue: {
                self.objectWillChange.send()
            })
        }
    }

    
    var memory: Memory {
        persistentMemory!.content
    }

    var isEmpty: Bool {
        persistentMemory == nil
    }

    private func persistentUrl(url: URL) -> URL {
        url.appendingPathComponent("memory." + HippocampusApp.persistentExtension)
    }

    func openMemory(url: URL) {
        persistentMemory = PersistentData<Memory>.init(url: persistentUrl(url: url), content: Memory())
    }

    func createMemory(name: String, local: Bool) {
        let url = HippocampusApp.memoryUrl(name: name, local: local)
        persistentMemory = PersistentData<Memory>.init(url: persistentUrl(url: url), content: Memory())
        persistentMemory!.commit()
    }

    func fleetingMemory(_ memory: Memory) {
        persistentMemory = PersistentData<Memory>.init(url: URL.virtual(), content: memory)
    }
    
    func commit() {
        persistentMemory?.commit()
    }
}

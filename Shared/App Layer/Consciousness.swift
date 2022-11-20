//
//  Consciousness.swift
//  Hippocampus
//
//  Created by Guido Kühn on 31.07.22.
//

import Combine
import Foundation

class Consciousness: ObservableObject {
    var cancellable: AnyCancellable?
    var _memory: Memory? {
        willSet {
            objectWillChange.send()
        }
        didSet {
            cancellable = _memory?.objectWillChange.sink(receiveValue: {
                self.objectWillChange.send()
            })
        }
    }

    var memory: Memory {
        _memory!
    }

    var isEmpty: Bool {
        _memory == nil
    }

    func openMemory(url: URL) {
        _memory = Memory(url: url)
    }

    func createMemory(name: String, local: Bool) {
        let url = HippocampusApp.memoryUrl(name: name, local: local)
        if !local {
            try? FileManager.default.startDownloadingUbiquitousItem(at: url)
        }
        let memory = Memory(url: url)
//        memory.commit()
        _memory = memory
    }

    func showMemory(_ memory: Memory) {
        _memory = memory
    }

    func commit() {
        memory.commit()
    }

    convenience init(name: String, local: Bool) {
        self.init()
        createMemory(name: name, local: local)
    }

    @Published var currentThought: Mind.Thought? = Mind.Thought.notes
    @Published var currentExperience: Imagination.Experience?
}

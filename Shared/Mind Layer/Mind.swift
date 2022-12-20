//
//  Mind.swift
//  Hippocampus
//
//  Created by Guido Kühn on 08.08.22.
//

import Combine
import Foundation

final class Mind: Serializable, ObservableObject, PersistentContent {
    let objectDidChange = PassthroughSubject<Void, Never>()

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

    func restore() {
        customPerspectives.values.forEach { perspective in
            perspective.aspects.forEach { aspect in
                aspect.perspective = perspective
            }
        }
    }

    @PublishedSerialized private var customThoughts: [Thought.ID: Thought] = [:]

    var thoughts: [Thought.ID: Thought] {
//        customThoughts
        Thought.globalThoughts.merging(customThoughts, uniquingKeysWith: { $1 })
    }

    func add(thought: Thought) {
        guard customThoughts[thought.id] == nil else { return }

        customThoughts[thought.id] = thought
    }

//    @Serialized private var topicId: Topic.ID = 0
//    @PublishedSerialized private var customTopics: [Topic.ID: Topic] = [:]
//
//    var topics: [Topic.ID: Topic] {
//        Topic.topics.merging(customTopics, uniquingKeysWith: { $1 })
//    }

//    func add(topic: Topic) {
//        guard topics[topic.id] == nil else { return }
//        if topic.id == 0 {
//            topicId += 1
//            topic.id = topicId
//        }
//        customTopics[topic.id] = topic
//    }

    @PublishedSerialized private var customPerspectives: [Perspective.ID: Perspective] = [:]

    var perspectives: [Perspective.ID: Perspective] {
        Perspective.globalPerspectives.merging(customPerspectives, uniquingKeysWith: { $1 })
    }

    func add(perspective: Perspective) {
        guard customPerspectives[perspective.id] == nil else { return }

        customPerspectives[perspective.id] = perspective
    }
}

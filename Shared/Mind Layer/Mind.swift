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

    func recover() {
        customPerspectives.values.forEach { perspective in
            perspective.aspects.forEach { aspect in
                aspect.perspective = perspective
            }
        }
    }

    @Serialized private var thoughtId: Thought.ID = 0
    @PublishedSerialized private var customThoughts: [Thought.ID: Thought] = [:]

    var thoughts: [Thought.ID: Thought] {
//        customThoughts
        Thought.thoughts.merging(customThoughts, uniquingKeysWith: { $1 })
    }

    func add(thought: Thought) {
        if thought.id == 0 {
            thoughtId += 1
            thought.id = thoughtId
        }
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

    @Serialized private var perspectiveId: Perspective.ID = 0
    @PublishedSerialized private var customPerspectives: [Perspective.ID: Perspective] = [:]

    var perspectives: [Perspective.ID: Perspective] {
        Perspective.perspectives.merging(customPerspectives, uniquingKeysWith: { $1 })
    }
    
    
    func add(perspective: Perspective) {
        guard customPerspectives[perspective.id] == nil else { return }
        if perspective.id == 0 {
            perspectiveId += 1
            perspective.id = perspectiveId
        }
        customPerspectives[perspective.id] = perspective
    }
}

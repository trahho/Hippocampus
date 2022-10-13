//
//  Vision.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 22.09.22.
//

import Combine
import Foundation

final class Senses: Serializable, ObservableObject {
    var cancellable: AnyCancellable?
    private var _mind: Mind? {
        willSet {
            objectWillChange.send()
        }
        didSet {
            cancellable = _mind?.objectWillChange.sink(receiveValue: {
                self.objectWillChange.send()
            })
        }
    }

    var mind: Mind {
        _mind!
    }

    var isEmpty: Bool {
        _mind == nil
    }

    func adoptMind(_ mind: Mind) {
        _mind = mind
    }

    func recover() {
//        customPerspectives.values.forEach { perspective in
//            perspective.aspects.forEach { aspect in
//                aspect.perspective = perspective
//            }
//        }
    }

   

//    @Serialized private var visionId: Thought.ID = 0
    ////    @PublishedSerialized private var customThoughts: [Thought.ID: Thought] = [:]
//
//    var thoughts: [Thought.ID: Thought] {
//        customThoughts
    ////        Thought.thoughts.merging(customThoughts, uniquingKeysWith: { $1 })
//    }
//
//    func add(thought: Thought) {
//        if thought.id == 0 {
//            thoughtId += 1
//            thought.id = thoughtId
//        }
//        customThoughts[thought.id] = thought
//    }
//
//    @Serialized private var topicId: Topic.ID = 0
//    @PublishedSerialized private var customTopics: [Topic.ID: Topic] = [:]
//
//    var topics: [Topic.ID: Topic] {
//        Topic.topics.merging(customTopics, uniquingKeysWith: { $1 })
//    }
//
//    func add(topic: Topic) {
//        guard topics[topic.id] == nil else { return }
//        if topic.id == 0 {
//            topicId += 1
//            topic.id = topicId
//        }
//        customTopics[topic.id] = topic
//    }
//
//    @Serialized private var perspectiveId: Perspective.ID = 0
//    @PublishedSerialized private var customPerspectives: [Perspective.ID: Perspective] = [:]
//
//    var perspectives: [Perspective.ID: Perspective] {
//        Perspective.perspectives.merging(customPerspectives, uniquingKeysWith: { $1 })
//    }
//
//    func add(perspective: Perspective) {
//        guard customPerspectives[perspective.id] == nil else { return }
//        if perspective.id == 0 {
//            perspectiveId += 1
//            perspective.id = perspectiveId
//        }
//        customPerspectives[perspective.id] = perspective
//    }
}

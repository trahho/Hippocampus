//
//  Vision.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 22.09.22.
//

import Combine
import Foundation

final class Imagination: Serializable, ObservableObject, PersistentContent {
    func merge(other: Imagination) throws {
        throw Brain.Stroke.mergeFailed
    }
    
    var objectDidChange: ObservableObjectPublisher = ObjectDidChangePublisher()

    static var globalExperiences: [Mind.Thought.ID: [Experience]] = [
        Mind.Thought.notes.id: [
            Experience("Zeitliste", .list),
            Experience("Themas", .tree)
        ],
        Mind.Thought.drawings.id: [
            Experience("Ordner", .tree)
        ]
    ]

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

    func restore() {
//        customPerspectives.values.forEach { perspective in
//            perspective.aspects.forEach { aspect in
//                aspect.perspective = perspective
//            }
//        }
    }

    @Serialized var customExperiences: [Mind.Thought.ID: [Experience]] = .init()

    var experiences: [Mind.Thought.ID: [Experience]] {
        var result = [Mind.Thought.ID: [Experience]]()
        Imagination.globalExperiences.forEach { (key: Mind.Thought.ID, value: [Experience]) in
            result[key] = value
        }
        customExperiences.forEach { (key: Mind.Thought.ID, value: [Experience]) in
            result[key] = (result[key] ?? []) + value
        }
        return result
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

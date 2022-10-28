//
//  Brain.Information.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation

extension Brain {
    class Information: PersistentObject, ObservableObject, AspectStorage {
        struct PointInTime: Serializable {
            init() {}

            @Serialized private(set) var time: Date
            @Serialized private(set) var data: Codable?

            init(time: Date, data: Codable?) {
                self.time = time
                self.data = data
            }
        }

        @PublishedSerialized private(set) var perspectives: Set<Perspective.ID> = []
        @PublishedSerialized private(set) var aspects: [Aspect.ID: [PointInTime]] = [:]

        var _currentMoment: Date?
        var currentMoment: Date {
            _currentMoment ?? Date()
        }

        func remember(at timePoint: Date) {
            guard timePoint < Date() else { return }
            objectWillChange.send()
            _currentMoment = timePoint
        }

        func awaken() {
            guard _currentMoment == nil else { return }
            objectWillChange.send()
            _currentMoment = nil
        }

        required init() {}

        func takesPerspective(_ id: Perspective.ID) -> Bool {
            perspectives.contains(id)
        }

        func takePerspective(_ id: Perspective.ID) {
            perspectives.insert(id)
        }

        subscript(_ key: Aspect.ID) -> Codable? {
            get {
                aspects[key]?.last(where: { $0.time <= currentMoment })
            }
            set {
                let timeLine = aspects[key]
                if timeLine?.isEmpty ?? true {
                    aspects[key] = [PointInTime(time: currentMoment, data: newValue)]
                } else if let timeLine, !timeLine.contains(where: { $0.time >= currentMoment }) {
                    aspects[key]!.append(PointInTime(time: currentMoment, data: newValue))
                }
            }
        }
    }
}

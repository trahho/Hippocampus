//
//  Brain.Information.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation

extension Brain {
    class Information: PersistentObject, ObservableObject, AspectStorage {
        private static var _currentMoment: Date?
        static var currentMoment: Date {
            _currentMoment ?? Date()
        }

        func remember(at timePoint: Date) {
            guard Information._currentMoment == nil, timePoint <= Date() else { return }
            objectWillChange.send()
            Information._currentMoment = timePoint
        }

        func awaken() {
            guard Information._currentMoment == nil else { return }
            objectWillChange.send()
            Information._currentMoment = nil
        }

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

        required init() {}

        func takesPerspective(_ id: Perspective.ID) -> Bool {
            perspectives.contains(id)
        }

        func takePerspective(_ id: Perspective.ID) {
            perspectives.insert(id)
        }

        subscript(_ key: Aspect.ID) -> Codable? {
            get {
                let currentMoment = Information.currentMoment
                return aspects[key]?.last(where: { $0.time <= currentMoment })
            }
            set {
                let timeLine = aspects[key]
                let currentMoment = Information.currentMoment
                if timeLine?.isEmpty ?? true {
                    aspects[key] = [PointInTime(time: currentMoment, data: newValue)]
                } else if let timeLine, !timeLine.contains(where: { $0.time >= currentMoment }) {
                    aspects[key]!.append(PointInTime(time: currentMoment, data: newValue))
                }
            }
        }
    }
}

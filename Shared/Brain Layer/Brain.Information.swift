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

        required init() {}

        func takesPerspective(_ id: Perspective.ID) -> Bool {
            perspectives.contains(id)
        }

        func takePerspective(_ id: Perspective.ID) {
            perspectives.insert(id)
        }

        subscript(_ key: Aspect.ID) -> Codable? {
            get {
                return aspects[key]?.last(where: { $0.time <= currentMoment })
            }
            set {
                let currentMoment = currentMoment

                if let timeLine = aspects[key], let last = timeLine.last {
                    if last.time <= currentMoment {
                        if last.time == currentMoment {
                            aspects[key]!.removeLast()
                        }
                        aspects[key]!.append(PointInTime(time: currentMoment, data: newValue))
                    }
                } else {
                    aspects[key] = [PointInTime(time: currentMoment, data: newValue)]
                }
            }
        }
    }
}

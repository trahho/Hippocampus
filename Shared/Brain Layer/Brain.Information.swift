//
//  Brain.Information.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.22.
//

import Foundation

// protocol InformationManager {
//    func changeHappened(information: Brain.Information)
//    var currentMoment: Date { get }
// }

extension Brain {
    class Information: PersistentObject, ObservableObject, AspectStorage {
   
        
        struct PointInTime: Serializable {
            init() {}

            @Serialized private(set) var time: Date
            @Serialized private(set) var point: Aspect.Point

            init(time: Date, point: Aspect.Point) {
                self.time = time
                self.point = point
            }
        }

//        struct PointInTime: Codable {
//            var time: Date
//            var data: Codable?
//
//            init(time: Date, data: Codable?) {
//                self.time = time
//                self.data = data
//            }
//        }

        @Serialized private(set) var perspectives: Set<Perspective.ID> = []
        @Serialized private(set) var aspects: [Aspect.ID: [PointInTime]] = [:]
        var brain: Brain!

        required init() {}

        func takesPerspective(_ id: Perspective.ID) -> Bool {
            perspectives.contains(id)
        }

        func takePerspective(_ id: Perspective.ID) {
            perspectives.insert(id)
        }

        func forget(moment: Date) {
            guard brain.dreaming else { return }
            aspects.forEach { (key: Aspect.ID, value: [PointInTime]) in
                aspects[key] = value.filter { $0.time < moment }
            }
        }

        subscript(_ key: Aspect.ID) -> Aspect.Point {
            get {
                let result = aspects[key]?.last(where: { $0.time <= brain.currentMoment ?? Date() })
                return result?.point ?? .empty
            }
            set {
                brain.dream {
                    guard let currentMoment = brain.currentMoment else { return }

                    if let timeLine = aspects[key], let last = timeLine.last {
                        if last.time <= currentMoment {
                            if last.time == currentMoment {
                                aspects[key]!.removeLast()
                            }
                            aspects[key]!.append(PointInTime(time: currentMoment, point: newValue))
                        }
                    } else {
                        aspects[key] = [PointInTime(time: currentMoment, point: newValue)]
                    }

                    brain.addChange(.modified(self, currentMoment))
                }
            }
        }
    }
}

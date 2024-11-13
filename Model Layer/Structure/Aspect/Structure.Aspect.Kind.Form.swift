//
//  Format.swift
//  Hippocampus
//
//  Created by Guido Kühn on 06.08.24.
//

import Grisu

extension Structure.Aspect.Kind {
    enum Form: Structure.PersistentValue, PickableEnum {
        case date, weekday, time

        // MARK: Computed Properties

        var description: String {
            switch self {
            case .date:
                "date"
            case .weekday:
                "weekday"
            case .time:
                "time"
            }
        }
    }
}

//
//  Structure.Aspect.Kind.Format.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.07.24.
//

import Grisu

extension Structure.Aspect.Kind {
    enum Format: Structure.PersistentValue, PickableEnum {
        case full, date, time, short

        // MARK: Computed Properties

        var description: String {
            switch self {
            case .date:
                "date"
            case .full:
                "full"
            case .short:
                "short"
            case .time:
                "time"
            }
        }
    }
}

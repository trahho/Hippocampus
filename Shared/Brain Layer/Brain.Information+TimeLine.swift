//
//  Brain.Information+TimeLine.swift
//  Hippocampus
//
//  Created by Guido Kühn on 28.10.22.
//

import Foundation

extension Brain.Information {
    private static var _currentMoment: Date?
    
    var currentMoment: Date {
        Self._currentMoment ?? Date()
    }

    func remember(at timePoint: Date) {
        guard Self._currentMoment == nil, timePoint <= Date() else { return }
        objectWillChange.send()
        Self._currentMoment = timePoint
    }

    func awaken() {
        guard Self._currentMoment == nil else { return }
        objectWillChange.send()
        Self._currentMoment = nil
    }
}

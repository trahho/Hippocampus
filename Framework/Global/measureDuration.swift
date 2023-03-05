//
//  measureDuration.swift
//  Hippocampus
//
//  Created by Guido Kühn on 05.03.23.
//

import Foundation

func measureDuration(_ tag: String, _ action: () -> ()) {
    let start = Date()
    action()
    let end = Date()
    print("\(tag): \(end.timeIntervalSince(start))")
}

//
//  Set+asArray.swift
//  Hippocampus
//
//  Created by Guido Kühn on 29.05.22.
//

import Foundation

extension Set {
    var asArray: [Element] {
        Array(self)
    }
}

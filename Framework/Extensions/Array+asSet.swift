//
//  Array+asSet.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.05.22.
//

import Foundation

extension Array where Element: Hashable {
    var asSet: Set<Element> {
        Set(self)
    }
}

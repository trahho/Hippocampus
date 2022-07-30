//
//  DataFieldKey.swift
//  Hippocampus
//
//  Created by Guido Kühn on 13.05.22.
//

import Foundation

protocol DataFieldKey: RawRepresentable where RawValue == String {
    var key: String {
        get
    }
}

struct DataFieldKeyRepresenter: DataFieldKey {
    var rawValue: String
}

extension DataFieldKey {
    var key: String {
        rawValue
    }

    static func + (lhs: Self, rhs: Self) -> DataFieldKeyRepresenter {
        DataFieldKeyRepresenter(rawValue: lhs.key + "." + rhs.key)
    }
}

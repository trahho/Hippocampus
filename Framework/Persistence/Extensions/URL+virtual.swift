//
//  URL+virtual.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 02.12.22.
//

import Foundation

extension URL {
    var isVirtual: Bool {
        scheme == "virtual"
    }

    static func virtual() -> URL {
        URL(string: "virtual:///")!
    }
}

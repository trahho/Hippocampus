//
//  RestorableContent.swift
//  Hippocampus
//
//  Created by Guido Kühn on 28.04.23.
//

import Foundation

public protocol RestorableContent {
    func restore(content: RestorableContent?)
}

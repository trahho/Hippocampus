//
//  MergeableContent.swift
//  Hippocampus
//
//  Created by Guido Kühn on 28.04.23.
//

import Foundation

public protocol MergeableContent {
    func merge(other: any MergeableContent) throws
}

enum MergeableContentMergeError: Error {
    case wrongMatch
    case mergeFailed
}

public extension MergeableContent {
    func merge(other: any MergeableContent) throws {
        throw MergeableContentMergeError.mergeFailed
    }
}

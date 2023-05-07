//
//  PresentationResult.swift
//  Hippocampus
//
//  Created by Guido Kühn on 07.05.23.
//

import Foundation
import Smaug

class PresentationResult: ObjectMemory {
    @Objects var nodes: Set<Node>
    @Objects var edges: Set<Edge>
    @Objects var results: Set<Result>
}

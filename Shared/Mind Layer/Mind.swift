//
//  Mind.swift
//  Hippocampus
//
//  Created by Guido Kühn on 08.08.22.
//

import Combine
import Foundation

final class Mind: PersistentData {
    @Present var thoughts: Set<Thought>
}

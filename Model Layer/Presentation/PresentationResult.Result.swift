//
//  Structure.Query.Result.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import Smaug

// extension Set<Structure.Role> {
//    func contains(_ memberId: Structure.Role.ID) -> Bool {
//        contains { role in
//            role.id == memberId
//        }
//    }
// }

extension Presentation.PresentationResult {
    class Result: Object {
        @Object var query: Presentation.Query!
        @Objects var items: Set<Item>
    }
}

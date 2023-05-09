//
//  PresentationResult.Item.swift
//  Hippocampus
//
//  Created by Guido Kühn on 08.05.23.
//

import Foundation
import Smaug

extension Presentation.PresentationResult {
    class Item: Object {
        @Object var item: Information.Item!
        @Objects var roles: Set<Structure.Role>
        @Objects var next: Set<Item>
        
        init(item: Information.Item, roles: Set<Structure.Role>) {
            super.init()
            self.roles = roles.intersection(item.roles)
            self.item = item
        }
        
        required init() {}
    }
}

//
//  Presentation.PropertiesCache.swift
//  Hippocampus
//
//  Created by Guido Kühn on 08.07.24.
//

import Foundation
import Smaug

extension Presentation {
    class Properties: DatabaseDocument {
        typealias Properties = PropertiesStore.Properties
        // MARK: Internal

        class PropertiesStore: PropertyStore {
            class Properties: ObjectPersistence.Object {
                @Property var role: Structure.Role.ID?
            }

            @Property var properties: [Information.Item.ID: Properties] = [:]
        }

        func callAsFunction(item: Information.Item, role: Structure.Role? = nil) -> PropertiesStore.Properties {
            if let result = properties.properties[item.id] { return result }
            let result = PropertiesStore.Properties()
            result.role = role?.id
            properties.properties[item.id] = result
            return result
        }

        // MARK: Private

        @Property private var properties = PropertiesStore()
    }
}

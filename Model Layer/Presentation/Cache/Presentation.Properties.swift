//
//  Presentation.PropertiesCache.swift
//  Hippocampus
//
//  Created by Guido Kühn on 08.07.24.
//

import Foundation
import Smaug

extension Presentation {
    class Properties: CacheDatabaseDocument {
        typealias Properties = PropertiesStore.Properties
        // MARK: Internal

        class PropertiesStore: PropertyStore {
            class Properties: ObjectPersistence.Object {
                @Property var perspective: Structure.Perspective.ID?
            }

            @Property var properties: [Information.Item.ID: Properties] = [:]
        }

        func callAsFunction(item: Information.Item, perspective: Structure.Perspective? = nil) -> PropertiesStore.Properties {
            if let result = properties.properties[item.id] { return result }
            let result = PropertiesStore.Properties()
            result.perspective = perspective?.id
            properties.properties[item.id] = result
            return result
        }

        // MARK: Private

        @Property private var properties = PropertiesStore()
    }
}

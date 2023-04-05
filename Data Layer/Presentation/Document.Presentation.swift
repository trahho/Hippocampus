//
//  Document.Presentation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.03.23.
//

import Foundation

extension Document {
    class Presentation: ObservableObject {
        @Observed private var propertiesContainer: PersistentContainer<Properties>
        
        init(url: URL, name: String) {
            let url = url.appending(components: "presentations", name)
            propertiesContainer = PersistentContainer(url: url.appending(component: "properties"), content: Properties(), commitOnChange: true)
        }
    }
}

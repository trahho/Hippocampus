//
//  Document.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation

class Document: ObservableObject {
    @Observed var informationContainer: PersistentContainer<Information>
    @Observed var structureContainer: PersistentContainer<Structure>
    
    private (set) var url: URL

    var information: Information {
        informationContainer.content
    }

    var queries: Set<Structure.Query> {
        structureContainer.content.queries
    }

    var roles: Set<Structure.Role> {
        structureContainer.content.roles
    }

    init(url: URL) {
        self.url = url
        let informationUrl = url.appendingPathComponent("Information" + HippocampusApp.persistentExtension)
        let structureUrl = url.appendingPathComponent("Structure" + HippocampusApp.persistentExtension)
        informationContainer = PersistentContainer(url: informationUrl, content: Information(), commitOnChange: true)
        structureContainer = PersistentContainer(url: structureUrl, content: Structure().setup(), commitOnChange: true)
    }

    convenience init(name: String, local: Bool) {
        let url = HippocampusApp.documentURL(name: name, local: local)
        self.init(url: url)
    }

    func save() {
        informationContainer.save()
        structureContainer.save()
    }
}

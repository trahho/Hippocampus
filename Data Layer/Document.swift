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

    private(set) var url: URL

    var information: Information {
        informationContainer.content
    }

    var structure: Structure {
        structureContainer.content
    }

    var queries: Set<Structure.Query> {
        structure.queries
    }

    var roles: Set<Structure.Role> {
        structure.roles
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

    struct Cache<Content: AnyObject> {
        weak var content: Content?
    }

    private var drawings: [String: Cache<Drawing>] = [:]
    private var presentations: [String: Cache<Presentation>] = [:]

    func getDrawing(item: Information.Item, aspect: Structure.Aspect) -> Drawing {
        let title = "\(item.id)--\(aspect.id)"
        if let result = drawings[title]?.content {
            return result
        } else {
            let result = Drawing(url: url, name: title)
            drawings[title] = Cache(content: result)
            return result
        }
    }

    func getPresentation(query: Structure.Query) -> Presentation {
        let title = "\(query.id)"
        if let result = presentations[title]?.content {
            return result
        } else {
            let result = Presentation(url: url, name: title)
            presentations[title] = Cache(content: result)
            return result
        }
    }
}

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
    @Observed var presentationContainer: PersistentContainer<Presentation>

    private(set) var url: URL

    var information: Information {
        informationContainer.content
    }

    var structure: Structure {
        structureContainer.content
    }
    
    var presentation: Presentation {
        presentationContainer.content
    }

    var queries: Set<Presentation.Query> {
        presentation.queries
    }

    var roles: Set<Structure.Role> {
        structure.roles
    }

    init(url: URL) {
        self.url = url
        let informationUrl = url.appendingPathComponent("Information" + HippocampusApp.persistentExtension)
        let structureUrl = url.appendingPathComponent("Structure" + HippocampusApp.persistentExtension)
        let presentationUrl = url.appendingPathComponent("Presentation" + HippocampusApp.persistentExtension)

        informationContainer = PersistentContainer(url: informationUrl, content: Information(), commitOnChange: true)
        structureContainer = PersistentContainer(url: structureUrl, content: Structure().setup(), commitOnChange: true)
        presentationContainer = PersistentContainer(url: presentationUrl, content: Presentation().setup(), commitOnChange: true) { content in
            content.structureContainer = self.structureContainer
        }
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
    private var presentations: [String: Cache<PersistentContainer<Presentation.Properties>>] = [:]

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

    func getPresentation(query: Presentation.Query) -> Presentation.Properties {
        let title = "\(query.id)"
        if let result = presentations[title]?.content {
            return result.content
        } else {
            let url = url.appending(components: "presentations", title, "properties")
            let propertiesContainer = PersistentContainer(url: url, content: Presentation.Properties(), commitOnChange: true)
            presentations[title] = Cache(content: propertiesContainer)
            return propertiesContainer.content
        }
    }
}

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

    struct Cache<Content: AnyObject> {
        weak var content: Content?
    }

    private var drawings: [String: Cache<Drawing>] = [:]
//    private var views: [String: Cache<String>] = [:]

    func getDrawing(item: Information.Item, aspect: Structure.Aspect) -> Drawing {
        let title = "\(item.id)--\(aspect.id)"
        if let result = drawings[title]?.content {
           return result
        } else {
            let drawing = Drawing(document: self, name: title)
            drawings[title] = Cache(content: drawing)
            return drawing
        }
    }
    
  
    
//    func getDrawing(item: Information.Item, aspect: Structure.Aspect) -> Drawing {
//        let title = "\(item.id)--\(aspect.id)"
//        if let result = drawings[title] {
//            drawings[title] = (result.drawing, result.count + 1)
//            print("Drawing added: \(drawings[title]?.count ?? 0)")
//            return result.drawing
//        } else {
//            let drawing = Drawing(document: self, name: title)
//            drawings[title] = (drawing, 1)
//            print("Drawing added: \(drawings[title]?.count ?? 0)")
//            return drawing
//        }
//    }

//    func releaseDrawing(item: Information.Item, aspect: Structure.Aspect) {
//        let title = "\(item.id)--\(aspect.id)"
//        guard let result = drawings[title] else { return }
//        if result.count == 1 {
//            drawings.removeValue(forKey: title)
//        } else {
//            drawings[title] = (result.drawing, result.count - 1)
//        }
//        print("Drawing removed: \(drawings[title]?.count ?? 0)")
//    }
}

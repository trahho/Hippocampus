//
//  Document.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation
import Smaug

class Document: DatabaseDocument {
    @Data var information: Information
    @Data var structure: Structure
//    @Data var presentation: Presentation
//    @Transient var result: Presentation.PresentationResult
    @Cache var drawing: Document.Drawing

    convenience init(name: String, local: Bool) {
        let containerURL = local ? HippocampusApp.localContainerUrl : HippocampusApp.iCloudContainerUrl
        let url = containerURL.appendingPathComponent("\(name)\(HippocampusApp.memoryExtension)")
        self.init(url: url)
    }

    override func setup() {
        [Structure.Role]([.drawing, .hierarchical, .named, .text, .topic, .tracked]).forEach { self[] = $0 }
//        [Presentation.Query]([.general, .notes, .topics]).forEach { self[] = $0 }
//        [Presentation.Group]([.builtIn]).forEach { self[] = $0 }

//        let a = create(Information.Item.self)
//        a[String.self, Structure.Role.global.name] = "Hallo"
//        let b = create(Information.Item.self)
//        b[String.self, Structure.Role.global.name] = "liebe"
//        a.to.insert(b)
//        let c = create(Information.Item.self)
//        c[String.self, Structure.Role.global.name] = "Welt"
//        b.to.insert(c)
//        c.to.insert(a)
//
//        let d = create(Information.Item.self)
//        d[String.self, Structure.Role.global.name] = "wie"
//        a.to.insert(d)
//        let e = create(Information.Item.self)
//        e[String.self, Structure.Role.global.name] = "geht"
//                e.to.insert(e)
//        d.to.insert(e)
//        e.to.insert(a)

//        create(Information.Item.self)[String.self, Structure.Role.global.name] = "Hallo Welt"
//        let texts = ["Hallo", "liebe", "Welt", "wie", "geht", "es","dir", "??"]
//        for _ in 0..<30 {
//            let x = self(Information.Item.self)
//            x[String.self, Structure.Role.global.name] = texts.randomElement()
//            for _ in 0..<2 {
//                let y = information.items.filter { $0.from.isEmpty }.randomElement() ?? information.items.randomElement()
//                if x != y { x.to.insert(y!) }
//            }
//        }
    }
}

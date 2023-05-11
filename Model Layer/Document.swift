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
    @Data var presentation: Presentation
    @Transient var result: Presentation.PresentationResult
    @Cache var drawing: Document.Drawing

    convenience init(name: String, local: Bool) {
        let containerURL = local ? HippocampusApp.localContainerUrl : HippocampusApp.iCloudContainerUrl
        let url = containerURL.appendingPathComponent("\(name)\(HippocampusApp.memoryExtension)")
        self.init(url: url)
    }

    override func setup() {
        [Structure.Role]([.global, .drawing, .text, .topic, .note]).forEach {  self[]=$0  }
        [Presentation.Query]([.general, .notes, .topics]).forEach {  self[]=$0  }
        [Presentation.Group]([.builtIn]).forEach { self[]=$0 }
        
        let a = add(Information.Item.self)
        a[String.self, Structure.Role.global.name] = "Hallo"
        let b = add(Information.Item.self)
        b[String.self, Structure.Role.global.name] = "liebe"
        a.to.insert(b)
        let c = add(Information.Item.self)
        c[String.self, Structure.Role.global.name] = "Welt"
        b.to.insert(c)
//        c.to.insert(a)
    }
}

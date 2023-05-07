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
    @Transient var result: PresentationResult
    @Cache var drawing: Document.Drawing

    convenience init(name: String, local: Bool) {
        let containerURL = local ? HippocampusApp.localContainerUrl : HippocampusApp.iCloudContainerUrl
        let url = containerURL.appendingPathComponent("\(name)\(HippocampusApp.memoryExtension)")
        self.init(url: url)
    }

    override func setup() {
        [Structure.Role]([.global, .drawing, .text, .topic, .note]).forEach { add($0) }
        [Presentation.Query]([.general, .notes, .topics]).forEach { add($0) }
        [Presentation.Group]([.builtIn]).forEach { add($0) }
    }
}

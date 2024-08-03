//
//  Document.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.12.22.
//

import Foundation
import Smaug

class Document: DatabaseDocument {
    // MARK: Properties

    @Data var information: Information
    @Data var structure: Structure
    @Cache var drawing: Drawing
    @Cache var properties: Presentation.Properties

    // MARK: Lifecycle

    convenience init(name: String, local: Bool) {
        let containerURL = local ? HippocampusApp.localContainerUrl : HippocampusApp.iCloudContainerUrl
        let url = containerURL.appendingPathComponent("\(name)\(HippocampusApp.memoryExtension)")
        self.init(url: url)
    }

    // MARK: Overridden Functions

    override func setup() {
//        self[] = Structure.Filter.Statics().statics
//        Structure.Filter.setup(in: self)
        self[] = Structure.Filter.statics
        self[] = Structure.Role.statics
    }
}

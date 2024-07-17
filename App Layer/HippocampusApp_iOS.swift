//
//  HippocampusApp_iOS.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.07.24.
//

import SwiftUI

extension HippocampusApp: App {
    var body: some Scene {
        WindowGroup {
            DocumentView(document: document)
        }
        WindowGroup("Filter", for: Structure.Filter.ID.self) { $filterId in
            if let filterId, let filter = document[Structure.Filter.self, filterId] {
                FilterEditView(filter: filter)
                    .setDocument(document)
            }
        }
    }
}

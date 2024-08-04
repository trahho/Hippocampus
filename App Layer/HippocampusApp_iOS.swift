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
                .environment(\.document, document)
        }
        WindowGroup("Filter", for: Structure.Filter.ID.self) { $id in
            if let id, let filter = document[Structure.Filter.self, id] {
                FilterEditView(filter: filter)
                    .environment(\.document, document)
            }
        }
        WindowGroup("Role", for: Structure.Role.ID.self) { $id in
            if let id, let role = document[Structure.Role.self, id] {
                RoleEditView(role: role)
                    .environment(\.document, document)
            }
        }
    }
}

//
//  RoleEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 14.06.24.
//

import Grisu
import SwiftUI

struct RolesView: View {
    @Environment(Document.self) var document
    @State var role: Structure.Role.ID?
    @State var expanded: SectionExpansions = .init()

    var roles: [Structure.Role] {
        document.structure.roles
            .sorted(by: { $0.name.localized($0.isStatic) < $1.name.localized($1.isStatic) })
    }

    var body: some View {
        NavigationSplitView {
            List(roles, selection: $role) { role in
                Text(role.name.localized(role.isStatic))
            }
        } detail: {
            if let id = role, let role = document[Structure.Role.self, id] {
                RoleEditView(role: role)
                    .id(id)
            } else {
                EmptyView()
            }
        }
    }
}

#Preview {
    @State var document = HippocampusApp.previewDocument()
    document.structure.roles.forEach { $0.toggleStatic() }
    return RolesView()
        .environment(document)
}

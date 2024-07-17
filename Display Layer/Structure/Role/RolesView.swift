//
//  RoleEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 14.06.24.
//

import Grisu
import SwiftUI

struct RolesView: View {
    // MARK: Properties

    @Environment(\.document) var document
    @State var role: Structure.Role.ID?
    @State var expanded: Expansions = .init()

    // MARK: Computed Properties

    var roles: [Structure.Role] {
        document.structure.roles
            .filter { $0 != Structure.Role.same }
            .sorted(by: { $0.name.localized($0.isStatic) < $1.name.localized($1.isStatic) })
    }

    // MARK: Content

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
        .onAppear {
            document.structure.roles.forEach { $0.toggleStatic() }
            document.structure.aspects.forEach { $0.toggleStatic() }
        }
        .onDisappear {
            document.structure.roles.forEach { $0.toggleStatic() }
            document.structure.aspects.forEach { $0.toggleStatic() }
        }
        .toolbar {
            Button {
                let role = document(Structure.Role.self)
                self.role = role.id
            } label: {
                Image(systemName: "plus")
            }
            #if os(OSX)
                Button {
                    var result = """
                    extension Structure.Role {
                        typealias Role = Structure.Role
                        typealias Aspect = Structure.Aspect
                        typealias Particle = Structure.Particle


                    """
                    result += "\tstatic var statics: [Role] = [.same, "
                    result += document.structure.roles
                        .filter { $0 != Structure.Role.same }
                        .sorted(by: { $0.name < $1.name })
                        .map { ".\($0.name)" }
                        .joined(separator: ", ")
                    result += "]\n\n"

                    result += Structure.Role.same.sourceCode(tab: 0, inline: false, document: document) + "\n"
                    for role in document.structure.roles
                        .filter({ $0 != Structure.Role.same })
                        .sorted(by: { $0.name < $1.name })
                    {
                        result += role.sourceCode(tab: 0, inline: false, document: document) + "\n"
                    }
                    result += "}"
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(result, forType: .string)
                } label: {
                    Image(systemName: "function")
                }

            #endif
        }
    }
}

#Preview {
    @Previewable @State var document = HippocampusApp.editStaticRolesDocument
    return RolesView()
        .environment(document)
}

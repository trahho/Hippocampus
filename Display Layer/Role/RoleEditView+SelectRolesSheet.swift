//
//  RoleEditView+SelectRolesSheet.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.06.24.
//

import Foundation
import Grisu
import Smaug
import SwiftUI

extension RoleEditView {
    struct SelectRolesSheet: View {
        @Environment(Document.self) var document
        @Binding var role: Structure.Role

        struct Entry: Identifiable, Hashable {
            let item: Structure.Role
            let role: Structure.Role
            var id: Structure.Role.ID { role.id }
            var text: String { role.name.localized(role.isStatic) }

            var children: [Entry]? {
                let result = role.compatible
                    .filter { !$0.conforms(to: item) }
                    .sorted(by: { $0.name.localized($0.isStatic) < $1.name.localized($1.isStatic) })
                    .map { Entry(item: item, role: $0) }
                return result.isEmpty ? nil : result
            }
        }

        var roots: [Entry] {
            document.structure.roles
                .filter { $0.roles.isEmpty && $0 != Structure.Role.same && $0 != role }
                .sorted(by: { $0.name.localized($0.isStatic) < $1.name.localized($1.isStatic) })
                .map { Entry(item: role, role: $0) }
        }

        var body: some View {
            List(roots, children: \.children) { entry in
                HStack {
                    if role == entry.role {
                        Image(systemName: "circle.circle")
                    } else if role.compatible.contains(entry.role) {
                        Image(systemName: "xmark.circle")
                    } else if role.roles.contains(entry.role) {
                        Image(systemName: "checkmark.circle")
                    } else {
                        Image(systemName: "circle")
                    }
                    Text(entry.text)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    guard role != entry.role, !role.compatible.contains(entry.role) else { return }
                    if role.roles.contains(entry.role) {
                        role.roles.removeAll(where: { $0 == entry.role })
                    } else {
                        role.roles.append(entry.role)
                    }
                }
            }
        }
    }
}

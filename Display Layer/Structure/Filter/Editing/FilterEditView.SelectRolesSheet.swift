//
//  FilterEditView.SelectRolesSheet.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.07.24.
//

import SwiftUI

extension FilterEditView {
    struct SelectRolesSheet: View {
        // MARK: Nested Types

        struct Entry: Identifiable, Hashable {
            // MARK: Properties

//            let item: Structure.Role
            let role: Structure.Role

            // MARK: Computed Properties

            var id: Structure.Role.ID { role.id }
            var text: String { role.name.localized(role.isStatic) }

            var children: [Entry]? {
                let result = role.subRoles
                    .sorted(by: { $0.name.localized($0.isStatic) < $1.name.localized($1.isStatic) })
                    .map { Entry(role: $0) }
                return result.isEmpty ? nil : result
            }
        }

        // MARK: Properties

        @Environment(\.document) var document
        @Binding var filter: Structure.Filter

        // MARK: Computed Properties

        var roots: [Entry] {
            document.structure.roles
                .filter { $0 != Structure.Role.same }
                .sorted(by: { $0.name.localized($0.isStatic) < $1.name.localized($1.isStatic) })
                .map { Entry(role: $0) }
        }

        // MARK: Content

        var body: some View {
            List(roots, children: \.children) { entry in
                HStack {
                    if filter.roles.contains(entry.role) {
                        Image(systemName: "checkmark.circle")
                    } else {
                        Image(systemName: "circle")
                    }
                    Text(entry.text)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if filter.roles.contains(entry.role) {
                        filter.roles.removeAll(where: { $0 == entry.role })
                    } else {
                        filter.roles.append(entry.role)
                    }
                }
            }
        }
    }
}

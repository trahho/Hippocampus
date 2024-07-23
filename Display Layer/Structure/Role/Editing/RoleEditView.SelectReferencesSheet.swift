//
//  RoleEditView+SelectReferencesSheet.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.06.24.
//

import Foundation
import SwiftUI

extension RoleEditView {
    struct SelectReferencesSheet: View {
        @Environment(\.document) var document
        @Binding var role: Structure.Role
        
        struct Entry: Identifiable, Hashable {
            let item: Structure.Role
            let role: Structure.Role
            var id: Structure.Role.ID { role.id }
            var text: String { role.name.localized(role.isLocked) }
            var children: [Entry]? {
                let result = role.roles
                    .filter { $0 != item }
                    .sorted(by: { $0.name.localized($0.isLocked) < $1.name.localized($1.isLocked) })
                    .map { Entry(item: item, role: $0) }
                return result.isEmpty ? nil : result
            }
        }
        
        var roots: [Entry] {
            document.structure.roles
                .filter { $0.subRoles.isEmpty && $0 != role }
                .sorted(by: { $0.name.localized($0.isLocked) < $1.name.localized($1.isLocked) })
                .map { Entry(item: role, role: $0) }
        }
        
        var body: some View {
            List(roots, children: \.children) { entry in
                HStack {
                    if role == entry.role {
                        Image(systemName: "circle.circle")
                    } else if role.referencedBy.contains(entry.role) {
                        Image(systemName: "xmark.circle")
                    } else if role.references.contains(entry.role) {
                        Image(systemName: "checkmark.circle")
                    } else {
                        Image(systemName: "circle")
                    }
                    Text(entry.text)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    guard role != entry.role, !role.referencedBy.contains(entry.role) else { return }
                    if role.references.contains(entry.role) {
                        role.references.removeAll(where: { $0 == entry.role })
                    } else {
                        role.references.append(entry.role)
                    }
                }
            }
        }
    }
}

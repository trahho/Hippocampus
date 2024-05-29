//
//  LayoutItemView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.05.24.
//

import Foundation
import SwiftUI

struct LayoutItemView: View {
    @State var item: Information.Item
    @State var layout: Presentation.Layout
    @State var roles: [Structure.Role]

    func findPresentation(roles: [Structure.Role]) -> Presentation? {
        let presentations = roles
            .flatMap { $0.presentations }
            .filter {
                switch $0 {
                case let .named(_, _, layouts):
                    layouts.isEmpty || layouts.contains(layout)
                default:
                    false
                }
            }

        if presentations.isEmpty {
            let roles = roles.flatMap { $0.roles }.asSet.asArray
            let presentation = findPresentation(roles: roles)
            return presentation
        } else {
            return presentations.first
        }
    }

    var recommendedRoles: [Structure.Role] {
        let suggestedRoles = roles.flatMap { $0.allRoles }.asSet
        let presentRoles = item.presentRoles
        return suggestedRoles.intersection(presentRoles).asArray
    }

    var body: some View {
        HStack {
            if case let .named(_, presentation, _) = findPresentation(roles: recommendedRoles) {
                ItemPresentationView(presentation: presentation, item: item)
            } else {
                Image(systemName: "viewfinder.trianglebadge.exclamationmark")
            }
        }
    }
}

#Preview {
    let document = HippocampusApp.previewDocument()
    let item = Information.Item()
    let presentation =
//        Presentation.vertical([
//            .normal(.aspect(Structure.Role.text.text.id, appearance: .icon, editable: false)),
//            .normal(.aspect(Structure.Role.text.text.id, appearance: .normal, editable: false))
//        ], alignment: .leading)

        Presentation.exclosing(Presentation.exclosing(.aspect(Structure.Role.text.text.id, appearance: .normal, editable: false), header: .aspect(Structure.Role.text.text.id, appearance: .icon, editable: false)), header: .aspect(Structure.Role.text.text.id, appearance: .icon, editable: false))

    document[] = item

    item[String.self, Structure.Role.text.text] = "Hallo Welt🤩"
    item.roles.append(Structure.Role.text)
    return LayoutItemView(item: item, layout: .list, roles: item.roles)
        .environment(document.structure)
}

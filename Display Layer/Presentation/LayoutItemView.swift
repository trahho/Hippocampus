//
//  LayoutItemView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 26.05.24.
//

import Foundation
import SwiftUI

struct LayoutItemView: View {
    @Environment(Structure.Role.self) var role
    @State var item: Information.Item
    @State var layout: Presentation.Layout
    @State var appearance: Presentation.Appearance
    @State var selectedRole: Structure.Role?

//    func findPresentation(roles: [Structure.Role]) -> Presentation? {
//        let presentations = roles
//            .flatMap { $0.presentations }
////            .filter {
////                switch $0 {
////                case let .named(_, _, layouts, appearances):
////                    (layouts.isEmpty || layouts.contains(layout)) && (appearances.isEmpty || appearances.contains(appearance))
////                default:
////                    false
////                }
////            }
//
//        if presentations.isEmpty {
//            let roles = roles.flatMap { $0.roles }.asSet.asArray
//            return findPresentation(roles: roles)
//        } else {
//            return presentations.first
//        }
//    }

    var roles: [Structure.Role] {
        item.roles.filter { $0.conforms(to: role) }
    }

    var presentedRole: Structure.Role? {
        selectedRole ?? roles.first
    }

//    var presentation: Presentation {
//        guard let role = presentedRole,
//              let presentation = findPresentation(roles: [role])
//        else { return .empty }
//        return presentation
//    }

    var body: some View {
        ZStack {
//            let presentation = presentation
//            if presentation != .empty {
//                if !presentation.containsSequence {
//                    RoundedRectangle(cornerRadius: 6, style: .circular)
//                        .stroke(Color.gray)
//                }
//                ItemPresentationView(presentation: presentation, item: item, layout: layout, appearance: appearance)
//                    .environment(presentedRole)
//                    .padding(6)
//
//            } else {
            Image(systemName: "viewfinder.trianglebadge.exclamationmark")
//            }
        }
    }
}

// #Preview {
//    let document = HippocampusApp.previewDocument()
//    let item = Information.Item()
//    let presentation =
////        Presentation.vertical([
////            .normal(.aspect(Structure.Role.text.text.id, appearance: .icon, editable: false)),
////            .normal(.aspect(Structure.Role.text.text.id, appearance: .normal, editable: false))
////        ], alignment: .leading)
//
//        Presentation.exclosing(Presentation.exclosing(.aspect(Structure.Role.text.text.id, appearance: .normal, editable: false), header: .aspect(Structure.Role.text.text.id, appearance: .icon, editable: false)), header: .aspect(Structure.Role.text.text.id, appearance: .icon, editable: false))
//
//    document[] = item
//
//    item[String.self, Structure.Role.text.text] = "Hallo Welt🤩"
//    item.roles.append(Structure.Role.text)
//    return LayoutItemView(item: item, layout: .list, appearance: .normal)
//        .environment(Structure.Role.text)
//        .environment(document.structure)
// }

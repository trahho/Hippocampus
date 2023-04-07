//
//  TextView.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 11.03.23.
//

import Foundation
import SwiftUI

struct TextView: View {
    @ObservedObject var item: Information.Item
    var aspect: Structure.Aspect
    var form: Structure.Aspect.Presentation.Form
    var editable: Bool

    var body: some View {
        switch form {
        case .icon:
            Image(systemName: "text.quote")
        case .firstParagraph:
            let text = item[String.self, aspect] ?? ""
            Text(text.prefix(while: { $0 != "\n" }))
        default:
            if editable {
                if aspect.role.isStatic {
                    TextField(LocalizedStringKey(aspect.name), text: Binding(get: { item[String.self, aspect] ?? "" }, set: { item[String.self, aspect] = $0 }))
                        .textFieldStyle(.roundedBorder)
                } else {
                    TextField(aspect.name, text: Binding(get: { item[String.self, aspect] ?? "" }, set: { item[String.self, aspect] = $0 }))
                        .textFieldStyle(.roundedBorder)
                }
            } else {
                if let value = item[String.self, aspect] {
                    Text(value)
                } else if aspect.role.isStatic {
                    Text(LocalizedStringKey(aspect.name))
                } else {
                    Text(aspect.name)
                }
            }
        }
    }
}

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

    @ViewBuilder
    var editView: some View {
        if aspect.role.isStatic {
            VStack(alignment: .leading) {
                if let value = item[String.self, aspect], value != "" {
                    Text(LocalizedStringKey(aspect.name))
                        .font(.myLabel)
                }
                TextField(LocalizedStringKey(aspect.name), text: Binding(get: { item[String.self, aspect] ?? "" }, set: { item[String.self, aspect] = $0 }))
                    .textFieldStyle(.roundedBorder)
            }
        } else {
            VStack(alignment: .leading) {
                if let value = item[String.self, aspect], value != "" {
                    Text(LocalizedStringKey(aspect.name))
                        .font(.myLabel)
                }
                TextField(aspect.name, text: Binding(get: { item[String.self, aspect] ?? "" }, set: { item[String.self, aspect] = $0 }))
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    @ViewBuilder
    var labelView: some View {
        if let value = item[String.self, aspect] {
            Text(value)
        } else if aspect.role.isStatic {
            Text(LocalizedStringKey(aspect.name))
        } else {
            Text(aspect.name)
        }
    }

    var body: some View {
        switch form {
        case .icon:
            Image(systemName: "text.quote")
        case .firstParagraph:
            let text = item[String.self, aspect] ?? ""
            Text(text.prefix(while: { $0 != "\n" }))
        case .edit:
            editView
        default:
            if editable {
                editView
            } else {
                labelView
            }
        }
    }
}

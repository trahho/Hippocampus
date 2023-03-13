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
        default:
            if editable {
                TextField(aspect.name, text: Binding(get: { item[String.self, aspect] ?? "" }, set: {
                    item[String.self, aspect] = $0
                }))
            } else {
                Text(item[String.self, aspect] ?? "")
            }
        }
    }
}

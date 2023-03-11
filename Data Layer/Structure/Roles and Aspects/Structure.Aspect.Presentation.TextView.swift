//
//  Structure.Aspect.TextView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.01.23.
//

import Foundation
import SwiftUI

extension Structure.Aspect.Presentation {
    struct TextView: View {
        @ObservedObject var item: Information.Item
        var aspect: Structure.Aspect
        var form: Form
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
}

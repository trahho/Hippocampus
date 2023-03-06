//
//  Structure.Aspect.TextView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.01.23.
//

import Foundation
import SwiftUI

extension Structure.Aspect.Representation{
    struct TextView: View {
        @ObservedObject var item: Information.Item
        var aspect: Structure.Aspect
        var editable: Bool

        var body: some View {
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

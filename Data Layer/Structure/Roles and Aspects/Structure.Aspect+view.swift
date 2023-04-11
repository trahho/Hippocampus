//
//  Structure.Aspect+view.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.01.23.
//

import Foundation
import SwiftUI

extension Structure.Aspect {
    @ViewBuilder
    var textView: some View {
        if role.isStatic {
            Text(LocalizedStringKey(name))
        } else {
            Text(name)
        }
    }

    func view(for item: Information.Item, as form: Presentation.Form, editable: Bool) -> some View {
        presentation.view(for: item, in: self, as: form, editable: editable)
    }
}

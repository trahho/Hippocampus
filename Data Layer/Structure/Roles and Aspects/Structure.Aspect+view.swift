//
//  Structure.Aspect+view.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.01.23.
//

import Foundation
import SwiftUI

extension Structure.Aspect {
    func view(for item: Information.Item, as form: Presentation.Form, editable: Bool) -> some View {
        self.presentation.view(for:  item, in: self, as: form, editable: editable)
    }
}

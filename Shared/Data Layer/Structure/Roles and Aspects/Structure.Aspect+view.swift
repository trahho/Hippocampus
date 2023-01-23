//
//  Structure.Aspect+view.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.01.23.
//

import Foundation
import SwiftUI

extension Structure.Aspect {
    func view(for item: Information.Item, editable: Bool) -> some View {
        self.representation.view(for:  item, in: self, editable: editable)
    }
}

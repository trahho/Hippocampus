//
//  Structure.Query+textView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 07.04.23.
//

import Foundation
import SwiftUI

extension Presentation.Query {
    @ViewBuilder
    var textView: some View {
        if isStatic {
            Text(LocalizedStringKey(name))
        } else {
            Text(name)
        }
    }
}

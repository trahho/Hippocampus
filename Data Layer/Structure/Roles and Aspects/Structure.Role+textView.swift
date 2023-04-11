//
//  Structure.Role+textView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 07.04.23.
//

import Foundation
import SwiftUI

extension Structure.Role {
    var localizedDescription: any ExpressibleByStringInterpolation {
        isStatic ? LocalizedStringKey(roleDescription) : roleDescription
    }

    @ViewBuilder
    var textView: some View {
        if isStatic {
            Text(LocalizedStringKey(roleDescription))
        } else {
            Text(roleDescription)
        }
    }
}

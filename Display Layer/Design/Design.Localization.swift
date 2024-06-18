//
//  Design.Localization.swift
//  Hippocampus
//
//  Created by Guido Kühn on 17.06.24.
//

import SwiftUI

struct Design_Localization: View {
    let string = "Hello"
    var body: some View {
//        Text("Hello")
//        Text(string)
//        Text(string.localized)
//        Text(string.localized(true))
        Text(string.localized(false))
    }
}

#Preview {
    Design_Localization()
}

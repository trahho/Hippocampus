//
//  Design.Environment.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.08.24.
//

import SwiftUI

struct Design_Environment: View {
    // MARK: Nested Types

    struct SubView: View {
        // MARK: Properties

        @Environment(\.text) var text

        // MARK: Content

        var body: some View {
            Text(text)
        }
    }

    // MARK: Content

    var body: some View {
        VStack {
            SubView()
                .environment(\.text, "Hello, World!")
            SubView()
                .environment(\.text, "Hallo, Welt!")
        }
    }
}

#Preview {
    Design_Environment()
}

extension EnvironmentValues {
    @Entry var text: String = ""
}

//
//  Design.Background.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.08.24.
//

import SwiftUI

struct Design_Background: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(width: 300, height: 300)
            .visualEffect(material: .sidebar)
    }
}

struct VisualEffectBackground: NSViewRepresentable {
    // MARK: Properties

    private let material: NSVisualEffectView.Material
    private let blendingMode: NSVisualEffectView.BlendingMode
    private let isEmphasized: Bool

    // MARK: Lifecycle

    fileprivate init(
        material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode,
        emphasized: Bool
    ) {
        self.material = material
        self.blendingMode = blendingMode
        isEmphasized = emphasized
    }

    // MARK: Functions

    func makeNSView(context _: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()

        // Not certain how necessary this is
        view.autoresizingMask = [.width, .height]

        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = context.environment.visualEffectMaterial ?? material
        nsView.blendingMode = context.environment.visualEffectBlending ?? blendingMode
        nsView.isEmphasized = context.environment.visualEffectEmphasized ?? isEmphasized
    }
}

extension EnvironmentValues {
    @Entry var visualEffectMaterial: NSVisualEffectView.Material?
    @Entry var visualEffectBlending: NSVisualEffectView.BlendingMode?
    @Entry var visualEffectEmphasized: Bool?
}

extension View {
    func visualEffect(
        material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode = .behindWindow,
        emphasized: Bool = false
    ) -> some View {
        background(
            VisualEffectBackground(
                material: material,
                blendingMode: blendingMode,
                emphasized: emphasized
            )
        )
    }
}

#Preview {
    Design_Background()
}

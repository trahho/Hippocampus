//
//  Design.ContextMenu.swift
//  Hippocampus
//
//  Created by Guido Kühn on 31.05.23.
//

import SwiftUI

struct Design_ContextMenuView: View {
    @State var color: Color = .clear
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .padding()
            .background(color)
            .editMenu {
                EditMenuItem("Clear", action: { color = .clear})
                EditMenuItem("Cyan", action: { color = .cyan})
            }
    }
}

struct RedBorderMenuStyle: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .border(Color.red)
    }
}

struct Design_ContextMenuView_Previews: PreviewProvider {
    static var previews: some View {
        Design_ContextMenuView()
    }
}

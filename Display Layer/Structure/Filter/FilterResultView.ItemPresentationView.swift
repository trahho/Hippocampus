//
//  TreeView.ItemPresentationView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.07.24.
//

import SwiftUI
import Grisu

extension FilterResultView {
    struct ItemPresentationView: View {
        // MARK: Properties
        
        @Environment(\.structure) var structure
        @State var item: Information.Item
        @Binding var role: Structure.Role!
        @State var roles: [Structure.Role]
        @State var filter: Structure.Filter
        
        // MARK: Computed Properties
        
        var filterPresentation: Presentation? {
            filter.representations.filter { $0.condition.matches(item, sameRole: role, structure: structure) }.first?.presentation
        }
        
        var rolePresentation: Presentation? {
            role.representation(layout: .tree)?.presentation
        }
        
        var presentation: Presentation? {
            filterPresentation ?? rolePresentation
        }
        
        // MARK: Content
        
        var body: some View {
            Group {
                if let presentation {
                    PresentationView(presentation: presentation, item: item)
                        .sensitive
                } else {
                    Image(systemName: "questionmark.square.dashed")
                }
            }
            .contextMenu {
                Picker("Role", selection: $role) {
                    ForEach(roles) { role in
                        Text(role.name)
                            .tag(role)
                    }
                }
            }
        }
    }
}

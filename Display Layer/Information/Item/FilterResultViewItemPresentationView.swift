//
//  FilterResultViewItemPresentationView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 29.07.24.
//


import Grisu
import SwiftUI

extension FilterResultView{
    struct ItemView: View {
        // MARK: Properties
        
        @Environment(\.structure) var structure
        
        @State var item: Information.Item
        @State var filter: Structure.Filter
        @Binding var role: Structure.Role!
        @State var roles: [Structure.Role]
        @State var layout: Presentation.Layout
        
        // MARK: Computed Properties
        
        var filterPresentation: Presentation? {
            filter.representations.filter { $0.condition.matches(item, sameRole: role, structure: structure) }.first?.presentation
        }
        
        // MARK: Content
        
        var body: some View {
            ItemPresentationView(item: item, role: role, presentation: filterPresentation, layout: layout)
                .popoverMenu {
                    ForEach(roles) { role in
                        Text(role.name)
                            .onTapGesture {
                                self.role = role
                            }
                    }
                }
        }
    }
}

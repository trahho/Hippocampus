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
        
        @State var item: Structure.Filter.Result.Item
        @State var layout: Presentation.Layout
        
     
        
        // MARK: Computed Properties
        
        var filterPresentation: Presentation? {
            item.filter.representations.filter { $0.condition.matches(item.item, sameRole: item.role, structure: structure) }.first?.presentation
        }
        
        // MARK: Content
        
        var body: some View {
            ItemPresentationView(item: item.item, role: item.role, presentation: filterPresentation, layout: layout)
                .sensitive
                .popoverMenu {
                    ForEach(item.roles) { role in
                        Text(role.name)
                            .onTapGesture {
                                item.role = role
                            }
                    }
                }
        }
    }
}

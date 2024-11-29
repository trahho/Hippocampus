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
            item.filter.representations.filter { $0.condition.matches(item.item, samePerspective: item.perspective, structure: structure) }.first?.presentation
        }
        
        // MARK: Content
        
        var body: some View {
            ItemPresentationView(item: item.item, perspective: item.perspective, presentation: filterPresentation, layout: layout)
//                .sensitive
                .popoverMenu {
                    ForEach(item.perspectives) { perspective in
                        Text(perspective.name)
                            .onTapGesture {
                                item.perspective = perspective
                            }
                    }
                }
        }
    }
}

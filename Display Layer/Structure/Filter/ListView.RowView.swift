//
//  ListView.RowView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.07.24.
//

import Foundation
import SwiftUI

extension ListView {
    struct RowView: View {
        // MARK: Properties

        @Environment(\.information) var information
        @Environment(\.structure) var structure
        @State var item: Structure.Filter.Result.Item

        // MARK: Content

        @ViewBuilder var label: some View {
            FilterResultView.ItemView(item: item,  layout: .list)
                .padding(2)
                .contentShape(Rectangle())
                .onTapGesture {
                    item.isSelected.toggle()
                }
                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.accentColor, lineWidth: 2).hidden(!item.isSelected))
        }

        
        var body: some View {
            label
        }
    }
}

//
//  ListView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 06.07.24.
//

import Foundation
import Grisu
import SwiftUI

struct ListView: View {
    // MARK: Properties

    @Environment(\.information) var information
    @Environment(\.structure) var structure
    @Bindable var result: Structure.Filter.Result
    @State var expansions = Expansions(defaultExpansion: false)

    // MARK: Content

    var body: some View {
        List(result.items) { item in
            FilterResultView.ItemView(item: item, layout: .list)
                .padding(2)
                .contentShape(Rectangle())
                .onTapGesture {
                    item.isSelected = true
                }
                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.accentColor, lineWidth: 2).hidden(!item.isSelected))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
    }
}

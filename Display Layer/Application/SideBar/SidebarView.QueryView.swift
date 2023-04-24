//
//  SidebarView.QueryView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.04.23.
//

import Foundation
import SwiftUI

extension SidebarView {
    struct QueryView: View {
        @EnvironmentObject var navigation: Navigation
        @ObservedObject var query: Presentation.Query
        @Binding var editItem: Presentation.Object?

        var body: some View {
            HStack {
                Image(systemName: "doc.text.magnifyingglass")
                QueryNameView(query: query)
            }
            .padding([.leading], 0)
            .padding([.top, .bottom], nil)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                navigation.query = query
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button {
                    print("Edit Query")
                    editItem = query
                } label: {
                    Label("_editGroups", systemImage: "tray.and.arrow.down")
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(query == navigation.query ? Color.accentColor.opacity(0.8) : Color.clear)
            }
        }
    }
}

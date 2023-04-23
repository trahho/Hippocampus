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

        var body: some View {
            HStack {
                Image(systemName: "doc.text.magnifyingglass")
                query.textView
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                navigation.query = query
            }
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(query == navigation.query ? Color.accentColor.opacity(0.8) : Color.clear)
            }
        }
    }
}

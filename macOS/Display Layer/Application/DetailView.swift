//
//  DetailView.swift
//  Hippocampus (macOS)
//
//  Created by Guido Kühn on 24.03.23.
//

import Foundation
import SwiftUI

struct DetailView: View {
    @EnvironmentObject var navigation: Navigation

    var showQuery: Bool {
        navigation.query != nil
    }

    var showItem: Bool {
        navigation.item != nil
    }

    var body: some View {
        ZStack {
            if showQuery {
                QueryView(query: navigation.query!)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                if showItem {
                    QueryItemView(item: navigation.item!)
                        .background(.background)
                        .frame(width: 200, alignment: .topTrailing)
                }
            } else {
                Text("Empty")
            }
        }
    }
}

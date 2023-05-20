//
//  QueryView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 20.03.23.
//

import Foundation
import SwiftUI

struct QueryView: View {
    @EnvironmentObject var document: Document
    @ObservedObject var query: Presentation.Query

    @ViewBuilder
    var content: some View {
        if let item = query.items.last {
            ItemView(item: item.item, roles: item.roles)
                .toolbar {
                    Button {
                        query.items.removeLast()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            if query.items.count == 1 {
                                QueryNameView(query: query)
                            } else {
                                Text(query.items[query.items.count - 1].name)
                            }
                        }
                    }
                }
        } else {
            switch query.layout {
            case .list:
                QueryTreeView(query:query)
//                QueryListView(query: query)
            case .tree:
                QueryTreeView(query:query)
            default:
                Text("Not yet")
            }
        }
    }

    var body: some View {
        switch query.layout {
        case .list:
            QueryTreeView(query:query)
//                QueryListView(query: query)
        case .tree:
            QueryTreeView(query:query)
        case .map:
            QueryMapView(query: query)
        default:
            Text("Not yet")
        }
    }
}

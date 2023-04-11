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
    @ObservedObject var query: Structure.Query

    @ViewBuilder
    var content: some View {
        switch query.layout {
        case .list:
            QueryListView(information: document.information, query: query)
        case .tree:
            QueryTreeView(information: document.information, query: query)
        default:
            Text("Not yet")
        }
    }

    var body: some View {
        content
    }
}

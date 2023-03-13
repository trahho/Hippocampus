//
//  NavigationPoCView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.03.23.
//

import SwiftUI

struct NavigationPoCView: View {
    @State var columnVisibility: NavigationSplitViewVisibility = .detailOnly

    var body: some View {
//        NavigationSplitView(columnVisibility: $columnVisibility) {
//            Text("Body")
//        } content: {
//            Text("Content")
//                .navigationSplitViewColumnWidth(ideal: .infinity)
////            EmptyView()
//        } detail: {
//            Text("Detail")
//        }
        NavigationSplitView {
         Text("A")
        } detail: {
            NavigationSplitView{
                Text("B")
            } detail: {
                Text("C")
            }
        }

    }
}

struct NavigationPoCView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationPoCView(columnVisibility: .detailOnly)
    }
}

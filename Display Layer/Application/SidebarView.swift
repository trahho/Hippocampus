//
//  SidebarView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.03.23.
//

import Foundation
import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var navigation: Navigation
    @EnvironmentObject var document: Document
//    @State var selection: Structure.Query

   

    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading) {
                switch navigation.sidebar {
                case .queries:
                    List(document.queries.asArray.sorted(by: { $0.name < $1.name }), id: \.self, selection: $navigation.query) { query in
                        query.textView
                            .font(.myText)
//                            .background(query == navigation.query ? Color.accentColor : Color.clear)
                            .tapToSelectQuery(query)
                        //                    .contentShape(Rectangle())
                        //                    .onTapGesture {
                        //                        navigation.details.append(.queryContent(query))
                        //                    }
                    }
                    //            .listStyle(.sidebar)
                    .navigationTitle("Filter")
//                    .frame(maxWidth: .infinity)
                case .favorites:
                    EmptyView()
                }
            }
         
//        }
//    }
}

//
//  DetailView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.03.23.
//

import Foundation
import SwiftUI

struct DetailView: View {
    @EnvironmentObject var navigation: Navigation

    var body: some View {
        NavigationStack(path: $navigation.items) {
            if let query = navigation.query {
                QueryView(query: query)
                    .navigationDestination(for: Presentation.Query.Result.Item.self) { item in
                        QueryItemView(item: item)
                    }
            } else {
                Text("Empty")
            }
        }
    }
}

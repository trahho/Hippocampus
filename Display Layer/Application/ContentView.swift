//
//  ContentView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.04.23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigation: Navigation

    var body: some View {
        NavigationStack(path: $navigation.path) {
            if let query = navigation.query {
                QueryView(query: query)
                    .navigationDestination(for: Presentation.PresentationResult.Item.self) { item in
                        ItemView(item: item.item, roles: item.roles.asArray)
                    }
            } else {
                EmptyView()
            }
        }
    }
}

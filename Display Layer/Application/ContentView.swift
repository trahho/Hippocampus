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
            if navigation.sidebarMode == .queries, let query = navigation.query {
                QueryView(query: query)
                    .navigationDestination(for: Presentation.PresentationResult.Item.self) { item in
                        ItemView(item: item.item, roles: item.roles.asArray)
                    }
            } else if navigation.sidebarMode == .roles, let role = navigation.role {
                RoleView(role: role)
//                    .navigationDestination(for: Structure.Role.self) { item in
//                        ItemView(item: item.item, roles: item.roles.asArray)
//                    }
            } else {
                EmptyView()
            }
        }
    }
}

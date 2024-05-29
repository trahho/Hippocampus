//
//  DetailView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.05.24.
//

import SwiftUI

struct DetailView: View {
    
    @State var navigation : Navigation

    var body: some View {
        NavigationStack(path: $navigation.path) {
//            if navigation.sidebarMode == .queries, let query = navigation.query {
//                QueryView(query: query)
//                    .navigationDestination(for: Presentation.PresentationResult.Item.self) { item in
//                        ItemView(item: item.item, roles: item.roles.asArray)
//                    }
//            } else if navigation.sidebarMode == .roles, let role = navigation.role {
//                RoleView(role: role)
////                    .navigationDestination(for: Structure.Role.self) { item in
////                        ItemView(item: item.item, roles: item.roles.asArray)
////                    }
//            } else {
                EmptyView()
//            }
        }
    }
}

#Preview {
    DetailView(navigation: Navigation())
}

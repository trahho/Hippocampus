//
//  ListView.RowView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.07.24.
//

import Foundation
import SwiftUI

extension ListView {
    struct RowView: View {
        // MARK: Properties

        @Environment(\.information) var information
        @Environment(\.structure) var structure
        @State var item: Information.Item
        @Binding var selectedItem: Information.Item?
        @State var role: Structure.Role!
        @State var roles: [Structure.Role]
        @State var filter: Structure.Filter

        // MARK: Content

        var body: some View {
            FilterResultView.ItemView(item: item, filter: filter, role: $role, roles: roles, layout: .tree)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedItem = item
                }
        }
    }
}

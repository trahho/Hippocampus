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
        @State var role: Structure.Role!
        @State var roles: [Structure.Role]
        @State var filter: Structure.Filter

        // MARK: Content

        var body: some View {
            FilterResultView.ItemPresentationView(item: item, role: $role, roles: roles, filter: filter).sensitive
        }
    }
}

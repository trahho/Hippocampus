//
//  Navigation.Detail.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.03.23.
//

import Foundation
import SwiftUI

extension Navigation {
    enum Detail: Hashable {
        case query(Presentation.Query)
        case item(Information.Item, Set<Structure.Role>)

        @ViewBuilder
        var view: some View {
            switch self {
            case let .query(query):
                QueryView(query: query)
            case let .item(item, roles):
                ItemView(item: item, roles: roles)
            }
        }
    }
}

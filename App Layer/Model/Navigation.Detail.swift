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
        case item( Information.Item, Set<Structure.Role>)

        var view: some View {
            switch self {
            case let .query(query):
                return QueryView(query: query)
            case let .item(item, roles)
                return QueryItemView(item: <#T##Presentation.Query.Result.Item#>)
            }
        }

      
    }
}

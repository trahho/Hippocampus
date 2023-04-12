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
        case queryContent(Presentation.Query)
        case queryStructure(Presentation.Query)
        case queryItem(Presentation.Query, Presentation.Query.Result.Item)
        case informationItem(Information.Item)
        case test

        var view: some View {
            Rectangle()
                .fill(.red)
                .frame(width: 50, height: 50)
        }

        var query: Presentation.Query? {
            switch self {
            case let .queryContent(query):
                return query
            case let .queryStructure(query):
                return query
            case let .queryItem(query, _):
                return query
            default:
                return nil
            }
        }
    }
}

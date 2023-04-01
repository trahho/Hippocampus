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
        case queryContent(Structure.Query)
        case queryStructure(Structure.Query)
        case queryItem(Structure.Query, Structure.Query.Result.Item)
        case informationItem(Information.Item)
        case test

        var view: some View {
            Rectangle()
                .fill(.red)
                .frame(width: 50, height: 50)
        }

        var query: Structure.Query? {
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

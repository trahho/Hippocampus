//
//  FilterResultView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.05.24.
//

import Foundation
import SwiftUI

struct FilterResultView: View {
    @State var items: [Information.Item]
    @State var filter: Structure.Filter
    @State var order: Presentation.Order?
    @State var layout: Presentation.Layout?
    @State var index: Int

    var orders: [Presentation.Order] { filter.order }
    var condition: Information.Condition { .all(filter.allConditions) }

    var sequence: [Presentation.Sequence] {
        if let order = order ?? orders.first {
            return [.ordered(condition, order: [order])]
        } else {
            return [.unordered(condition)]
        }
    }
    
    var test: Structure.Filter {
        print("\(filter.name) Result")
        return filter
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(test.name)
            if let role = filter.role {
                SequenceView(items: items, sequences: sequence, layout: layout ?? filter.layouts.first ?? .list, appearance: .normal)
                    .environment(role)
            } else {
                EmptyView()
            }
        }
    }
}

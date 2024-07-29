//
//  FilterView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.05.24.
//

import Foundation
import Grisu
import SwiftUI

struct FilterView: View {
    // MARK: Properties

    @Environment(\.openWindow) var openWindow
    @State var filter: Structure.Filter
    @Binding var selected: Structure.Filter?
    @Binding var expansions: Expansions

    // MARK: Computed Properties

    var filters: [Structure.Filter] {
        filter.subFilters.sorted { $0.name < $1.name }
    }

    // MARK: Content

    @ViewBuilder var label: some View {
        ZStack {
            HStack {
                Image(systemName: filter.subFilters.isEmpty ? "light.recessed.fill" : "light.recessed.3.fill")
                Text("\(filter.name)")
            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(3)
//            .background {
//                if selected == filter {
//                    RoundedRectangle(cornerRadius: 6)
//                        .foregroundColor(.accentColor)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                }
//            }
//            .contentShape(Rectangle())
//            .onTapGesture {
//                guard selected != filter else { return }
////                print("\(selected != filter)")
////                withAnimation {
//                selected = filter
////                }
//            }
            .contextMenu {
                Button("Edit") {
                    openWindow(value: filter.id)
                }
            }
        }
    }

    var body: some View {
        if filters.isEmpty {
            label
        } else {
            DisclosureGroup(key: filter.id.uuidString, isExpanded: $expansions) {
                ForEach(filters, id: \.self) { filter in
                    FilterView(filter: filter, selected: $selected, expansions: $expansions)
                }
            } label: {
                label
            }
        }
    }
}

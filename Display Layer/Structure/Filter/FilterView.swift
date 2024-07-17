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
//    @Environment(Navigation.self) var navigation
    @Environment(\.openWindow) var openWindow
    @State var filter: Structure.Filter
    @Binding var selected: Structure.Filter?
    @Binding var expansions: Expansions

//    @Binding var expansions: [Structure.Filter.ID: Bool]
//
//    var expansion: Binding<Bool> {
//        Binding<Bool>(get: {
//            expansions[filter.id] ?? true
//        }, set: {
//            expansions[filter.id] = $0
//        })
//    }

    @ViewBuilder var label: some View {
        ZStack {
//            if navigation.filter == filter {
//                RoundedRectangle(cornerRadius: 3, style: .continuous)
            ////                    .background(Color.accentColor)
//                    .foregroundColor(.accentColor)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
            HStack {
                Image(systemName: filter.subFilters.isEmpty ? "light.recessed.fill" : "light.recessed.3.fill")
                Text("\(filter.name)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            //                .listRowBackground(Color.blue)
            .contentShape(Rectangle())
            .onTapGesture {
                guard selected != filter else { return }
                print("\(selected != filter)")
                withAnimation {
                    selected = filter
                }
            }
            .contextMenu {
                Button("Edit") {
                    openWindow(value: filter.id)
                }
            }
        }
    }

    var filters: [Structure.Filter] {
        filter.subFilters.sorted { $0.name < $1.name }
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

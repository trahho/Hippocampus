//
//  NavigationView_iOS.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 31.07.24.
//

import Grisu
import SwiftUI

struct NavigationView: View {
    @Environment(\.document) private var document
    @Environment(\.structure) private var structure

    @State var showInspector: Bool = false
    @State var expansions: Expansions = .init()

    var body: some View {
        NavigationSplitView {
            FiltersView(structure: document.structure, expansions: $expansions)
        } detail: {
            if let filter = structure.selectedFilter {
                FilterResultView(filter: filter)
                    .id(filter.id)
//                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(filter.name)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                showInspector.toggle()
                            } label: {
                                Image(systemName: "sidebar.right")
                            }
                            .hidden(structure.selectedFilter?.selectedItem == nil)
                        }
                    }
                    .onChange(of: filter.selectedItem) { oldValue, _ in
                        if oldValue == nil { showInspector = true }
                    }
            }
        }
        .inspector(isPresented: Binding(get: { structure.selectedFilter?.selectedItem != nil && showInspector }, set: { showInspector = $0 }), content: {
            if let item = structure.selectedFilter?.selectedItem {
                InspectorView(item: item)
                    .sensitive
            }
        })
    }
}

//#Preview {
//    NavigationView()
//        .environment(\.document, HippocampusApp.previewDocument)
//}

extension NavigationView {
    struct InspectorView: View {
        // MARK: Properties

        @State var item: Structure.Filter.Result.Item

        // MARK: Content

        var body: some View {
            VStack(alignment: .leading) {
                ItemInspectorView(item: item.item, perspective: item.perspective)
            }
            .frame(alignment: .topLeading)
            .formStyle(.grouped)
        }
    }
}

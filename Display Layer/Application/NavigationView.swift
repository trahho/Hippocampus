//
//  NavigationView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Grisu
import SwiftUI

struct NavigationView: View {
    // MARK: Nested Types

    struct RoleSelectionPopoverView: View {
        // MARK: Properties

        @Environment(\.document) var document
        @Environment(\.dismiss) var dismiss

        // MARK: Computed Properties

        var roles: [Structure.Role] {
            document[Structure.Role.self].filter { $0.subRoles.isEmpty && $0 != .same }.sorted { $0.description < $1.description }
        }

        // MARK: Content

        var body: some View {
            List(roles) { role in
                Button(role.description) {
                    let item = document(Information.Item.self)
                    item.roles.append(role)
                    dismiss()
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: Properties

//    @State var document: Document
    @Environment(\.dismiss) var dismiss
    @Environment(\.information) var information
//    @Bindable var navigation: Navigation
    @State var cv: NavigationSplitViewVisibility = .automatic
    @State var expansions = Expansions()
    @State var inspectorExpansions = Expansions()
    @State var filter: Structure.Filter?
    @State var selectedItem: Information.Item?
    @State var index: Int = 0
    @State var path = NavigationPath()

    @State var listWidth: CGFloat = 200
    @State var listWidthOffset: CGFloat = 0

    @State var listDragging = false

    // MARK: Computed Properties

    var showList: Bool {
        guard let filter = filter, !filter.roles.isEmpty else { return false }
        return [.list, .tree].contains(filter.layout)
    }

    var filterId: UUID {
        filter?.id ?? Structure.Role.same.id
    }

    var dragListWidth: some Gesture {
        DragGesture(coordinateSpace: .named("list"))
            .onChanged { value in
                listDragging = true
                listWidth = min(max(value.location.x, 150), 400)
            }
            .onEnded { _ in
//                listWidth = value.location.x
                listDragging = false
            }
    }

    // MARK: Content

    @ViewBuilder var filtersList: some View {
        FiltersView(expansions: $expansions, selection: $filter)
    }

    @ViewBuilder var filterResultList: some View {
        if let filter = filter, !filter.roles.isEmpty {
            FilterResultView(filter: filter, selectedItem: $selectedItem)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder var inspector: some View {
        if let selectedItem {
            ForEach(sections:
                ItemInspectorView(item: selectedItem)
                    .sensitive)
            { item in
                DisclosureGroup(key: "\(item.id)", isExpanded: $inspectorExpansions) {
                    item.content
                } label: {
                    item.header
                }
            }
        }
    }

    @ViewBuilder var detailView: some View {
//        NavigationStack(path: $path) {
        ZStack(alignment: .topLeading) {
//                if let filter = filter, let layout = navigation.layout, layout != .list, filter.layouts.contains(layout) {
            if !showList, let filter {
                FilterResultView(filter: filter, selectedItem: $selectedItem)
                // TODO: Hier später den Inspektor rechts ausklappbar zeigen.
            } else {
//                List {
                inspector
//                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                PopoverMenu {
                    RoleSelectionPopoverView()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
//        }
    }

    var body: some View {
        Group {
//            if twoColumn {
//                NavigationSplitView {
//                    filtersList
//                } content: {
//                    filterResultList
//                } detail: {
//                    detailView
//                }
//                .id(filterId)
//            } else {
            NavigationSplitView {
                filtersList
            } detail: {
                if showList {
                    HStack(alignment: .top, spacing: 0) {
                        filterResultList
                            .frame(width: listWidth + listWidthOffset)
                        Divider()
                            .overlay(Divider()
                                .padding(3)
                                .contentShape(Rectangle())
                                .cursor(.columnResize)
                                .gesture(dragListWidth)
                            )
                        detailView
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .coordinateSpace(.named("list"))
                } else {
                    detailView
                }
            }
            .id(filterId)
        }
//        }
    }
}

#Preview {
    var document = HippocampusApp.previewDocument
//    let navigation = Navigation()

    NavigationView()
        .environment(\.doc, document)
}

public extension View {
    func cursor(_ cursor: NSCursor, disabled: Bool = false) -> some View {
        if #available(macOS 13.0, *) {
            return self.onContinuousHover { phase in
                guard !disabled else { return }
                switch phase {
                case .active:
                    guard NSCursor.current != cursor else { return }
                    cursor.push()
                case .ended:
                    NSCursor.pop()
                }
            }
        } else {
            return onHover { inside in
                guard !disabled else { return }
                if inside {
                    cursor.push()
                } else {
                    NSCursor.pop()
                }
            }
        }
    }
}

extension View {
    func debugPrint(_ text: String) -> some View {
        print(text)
        return self
    }
}

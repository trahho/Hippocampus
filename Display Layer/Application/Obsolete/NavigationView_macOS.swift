////
////  NavigationView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 27.12.22.
////
//
//import Grisu
//import SwiftUI
//
//struct NavigationView: View {
//    // MARK: Nested Types
//
//    struct RoleSelectionPopoverView: View {
//        // MARK: Properties
//
//        @Environment(\.document) var document
//        @Environment(\.dismiss) var dismiss
//
//        // MARK: Computed Properties
//
//        var roles: [Structure.Role] {
//            document[Structure.Role.self].filter { $0.subRoles.isEmpty && $0 != .same }.sorted { $0.description < $1.description }
//        }
//
//        // MARK: Content
//
//        var body: some View {
//            List(roles) { role in
//                Button(role.description) {
//                    let item = document(Information.Item.self)
//                    item.roles.append(role)
//                    dismiss()
//                }
//                .buttonStyle(.plain)
//            }
//        }
//    }
//
//    // MARK: Properties
//
////    @State var document: Document
//    @Environment(\.dismiss) var dismiss
//    @Environment(\.document) var document
//    @Environment(\.information) var information
//    @Environment(\.structure) var structure
//
////    @Bindable var navigation: Navigation
//    @State var cv: NavigationSplitViewVisibility = .automatic
//    @State var expansions = Expansions()
//    @State var inspectorExpansions = Expansions()
//    @State var index: Int = 0
//
//    @State var listWidth: CGFloat = 200
//    @State var inspectorWidth: CGFloat = 200
//    @State var showInspector: Bool = false
//
//    // MARK: Computed Properties
//
//    var showList: Bool {
//        guard let filter = structure.selectedFilter, !filter.roles.isEmpty else { return false }
//        return [.list /* .tree */ ].contains(filter.layout)
//    }
//
//    var dragListWidth: some Gesture {
//        DragGesture(coordinateSpace: .named("list"))
//            .onChanged { value in
//                listWidth = min(max(value.location.x, 150), 400)
//            }
//    }
//
//    var dragInspectorWidth: some Gesture {
//        DragGesture(coordinateSpace: .named("inspector"))
//            .onChanged { value in
//                inspectorWidth = min(max(inspectorWidth - value.translation.width, 150), 400)
//            }
//    }
//
//    // MARK: Content
//
//    @ViewBuilder var filtersList: some View {
//        FiltersView(expansions: $expansions)
//    }
//
//    @ViewBuilder var filterResultList: some View {
//        if let filter = structure.selectedFilter, !filter.roles.isEmpty {
//            FilterResultView(filter: filter)
//                .navigationTitle(filter.name)
//                .id(filter.id)
//        } else {
//            EmptyView()
//        }
//    }
//
//    @ViewBuilder var inspector: some View {
//        if let filter = structure.selectedFilter, let item = filter.selectedItem {
//            Form {
//                ForEach(sections:
//                    ItemInspectorView(item: item)
//                        .id(item.id))
//                { item in
////                    Section(content: T##() -> View, header: T##() -> View)
//                    DisclosureGroup(key: "\(item.id)", isExpanded: $inspectorExpansions) {
//                        item.content
//                    } label: {
//                        item.header
//                    }
//                }
//            }
//        }
//    }
//
//    @ViewBuilder var listDetailView: some View {
//        HStack(alignment: .top, spacing: 0) {
//            filterResultList
//                .frame(width: listWidth)
//            Divider()
//                .overlay(Divider()
//                    .padding(3)
//                    .contentShape(Rectangle())
//                    .cursor(.columnResize)
//                    .gesture(dragListWidth)
//                )
//            detailView
////                .id(selectedItem?.id)
//        }
//        .frame(maxWidth: .infinity, alignment: .topLeading)
//        .coordinateSpace(.named("list"))
//    }
//
//    @ViewBuilder var detailView: some View {
//        ZStack(alignment: .topLeading) {
//            if !showList {
//                filterResultList
//                    .toolbar {
//                        ToolbarItem(placement: .primaryAction) {
//                            Button {
//                                showInspector.toggle()
//                            } label: {
//                                Image(systemName: "sidebar.right")
//                            }
//                            .hidden(structure.selectedFilter?.selectedItem == nil)
//                        }
//                    }
//                    .inspector(isPresented: $showInspector, content: {
//                        inspector
//                    })
//            } else {
//                inspector
//            }
//        }
//
////            ToolbarItemGroup(placement: .automatic) {
////                PopoverMenu {
////                    RoleSelectionPopoverView()
////                } label: {
////                    Image(systemName: "plus.circle.fill")
////                }
////            }
//
////        }
//    }
//
//    var body: some View {
//        NavigationSplitView {
//            filtersList
//        } detail: {
//            if showList {
//                listDetailView
//            } else {
//                detailView
//            }
//        }
////        .id(filterId)
//
////        }
//    }
//}
//
//#Preview {
////    let navigation = Navigation()
//
//    NavigationView()
//        .environment(\._document, HippocampusApp.previewDocument)
//}
//
//public extension View {
//    func cursor(_ cursor: NSCursor, disabled: Bool = false) -> some View {
//        if #available(macOS 13.0, *) {
//            return self.onContinuousHover { phase in
//                guard !disabled else { return }
//                switch phase {
//                case .active:
//                    guard NSCursor.current != cursor else { return }
//                    cursor.push()
//                case .ended:
//                    NSCursor.pop()
//                }
//            }
//        } else {
//            return onHover { inside in
//                guard !disabled else { return }
//                if inside {
//                    cursor.push()
//                } else {
//                    NSCursor.pop()
//                }
//            }
//        }
//    }
//}
//
//extension View {
//    func debugPrint(_ text: String) -> some View {
//        print(text)
//        return self
//    }
//}

//
//  NavigationSplitView.swift
//  Hippocampus (iOS)
//
//  Created by Guido Kühn on 23.04.23.
//

import Foundation
import SwiftUI

struct NavigationSplitView<SideBar: View, Content: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @State var showSidebar = false
    @ViewBuilder var sidebar: () -> SideBar
    @ViewBuilder var content: () -> Content
    @State var toolbarItems: [ToolbarItem] = []

    var sidebarWidth: CGFloat {
        verticalSizeClass == .compact || horizontalSizeClass == .compact ? UIScreen.main.bounds.width : 320
    }

    @ViewBuilder
    var header: some View {
        ZStack(alignment: .center) {
            HStack(alignment: .center) {
                ForEach(toolbarItems.filter { $0.placement == .leading }) { item in
                    item.view
                }
//                Text("\(toolbarItems.filter { $0.placement == .leading }.count)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .border(.red)

            HStack(alignment: .center) {
                ForEach(toolbarItems.filter { $0.placement == .center }) { item in
                    item.view
                }
//                Text("\(toolbarItems.filter { $0.placement == .center }.count) - \(toolbarItems.count)")
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .border(.blue)

            HStack(alignment: .center) {
                ForEach(toolbarItems.filter { $0.placement == .trailing }) { item in
                    item.view
                }
//                Text("\(toolbarItems.filter { $0.placement == .trailing }.count)")
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    @ViewBuilder
    var fullContent: some View {
        VStack(alignment: .leading) {
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbarItem(placement: .leading) {
            Button {
                withAnimation {
                    showSidebar.toggle()
                }
            } label: {
                Image(systemName: "sidebar.left")
                    .font(.system(size: 24))
            }
        }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
//            if showSidebar {
//                content()
//                    .background(Color.secondaryBackground)
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        withAnimation {
//                            showSidebar.toggle()
//                        }
//                    }
//            } else {
                content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(EdgeInsets(top: 80, leading: 8, bottom: 10, trailing: 5))
                .background(showSidebar ? Color.secondaryBackground : Color.background)
//            }

            sidebar()
                .frame(maxWidth: sidebarWidth, maxHeight: .infinity, alignment: .topLeading)

                .background(Color.background)
                .offset(x: showSidebar ? 0.0 : -sidebarWidth)
                .transition(.move(edge: .leading))
            
            header
                .toolbarItem(placement: .leading) {
                    Button {
                        withAnimation {
                            showSidebar.toggle()
                        }
                    } label: {
                        Image(systemName: "sidebar.left")
                            .font(.system(size: 24))
                    }
                }
        }
        .onPreferenceChange(ToolBarItemPreferenceKey.self) { preferences in
            DispatchQueue.main.async {
                print ("set \(preferences.count)")
                toolbarItems = preferences
            }
        }
    }
}

struct NavigationSplitView_Previews: PreviewProvider {
    static var previews: some View {
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
        @Environment(\.verticalSizeClass) var verticalSizeClass

        NavigationSplitView {
            VStack(alignment: .leading) {
                Text("A")
                Text("B")
            }
        } content: {
            Text("\(horizontalSizeClass.debugDescription) - \(verticalSizeClass.debugDescription)")
//            Text("Hallo")
                .toolbarItem(placement: .center) {
                    Text("Title")
                        .font(.myTitle)
                }
                .toolbarItem(placement: .trailing) {
                    Image(systemName: "plus")
                }
        }
    }
}

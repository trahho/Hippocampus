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
                let items = toolbarItems.filter { $0.placement == .leading }
                ForEach(items) { item in
                    item.view
                }
//                Text("\(items.count)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
//            .border(.red)

            HStack(alignment: .center) {
                let items = toolbarItems.filter { $0.placement == .center }
                ForEach(items) { item in
                    item.view
                }
//                Text("\(items.count)")
            }
            .frame(maxWidth: .infinity, alignment: .center)
//            .border(.blue)

            HStack(alignment: .center) {
                let items = toolbarItems.filter { $0.placement == .trailing }
                ForEach(items) { item in
                    item.view
                }
//                Text("\(items.count)")
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(EdgeInsets(top: 64, leading: 10, bottom: 10, trailing: 10))
                .background(showSidebar ? Color.secondaryBackground : Color.background)

            sidebar()
                .padding(EdgeInsets(top: 64, leading: 20, bottom: 10, trailing: 20))
                .frame(maxWidth: sidebarWidth, maxHeight: .infinity, alignment: .topLeading)

                .background(Color.background)
                .offset(x: showSidebar ? 0.0 : -sidebarWidth)
                .transition(.move(edge: .leading))

            header
                .padding(EdgeInsets(top: 12, leading: 20, bottom: 0, trailing: 20))
                .toolbarItem(placement: .leading) {
                    Button {
                        withAnimation {
                            showSidebar.toggle()
                        }
                    } label: {
                        Image(systemName: "sidebar.left")
                            .font(.system(size: 20))
                    }
                }
        }
        .onPreferenceChange(ToolBarItemPreferenceKey.self) { preferences in
            DispatchQueue.main.async {
//                print ("set \(preferences.count)")
                toolbarItems = preferences
            }
        }
    }
}

struct NavigationSplitView_Previews: PreviewProvider {
    static var previews: some View {
        Design_ShellView()
    }
}

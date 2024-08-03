//
//  Design.ToolbarItem.swift
//  Hippocampus
//
//  Created by Guido Kühn on 31.07.24.
//

import SwiftUI

struct Desgin_ToolbarItem: View {
    var body: some View {
        NavigationSplitView {
            List {
                Text("S")
            }
        } detail: {
            List {
                Text("D")
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("pc")
            }
            ToolbarItem(placement: .navigation) {
                Text("nv")
            }
            ToolbarItem(placement: .primaryAction) {
                Text("pr")
            }
            ToolbarItem(placement: .secondaryAction) {
                Text("sc")
            }
        }
        .navigationTitle("Navigation Title")

    }
}

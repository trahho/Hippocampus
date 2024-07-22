//
//  ExportSourceCodeView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.07.24.
//

import Grisu
import SwiftUI

struct ExportSourceCodeView: View {
    var body: some View {
        TabView {
            ExportRolesView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Roles")
                }
            ExportFiltersView()
                .tabItem {
                    Image(systemName: "camera.filters")
                    Text("Filters")
                }
        }
    }
}

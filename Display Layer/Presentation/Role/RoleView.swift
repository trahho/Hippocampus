//
//  RoleView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 13.05.23.
//

import SwiftUI

struct RoleView: View {
    @ObservedObject var role: Structure.Role

    var graph: Structure.RoleGraph {
        Structure.RoleGraph(role: role)
    }

    var body: some View {
        GraphView(graph: graph)
    }
}

struct RoleView_Previews: PreviewProvider {
    static let document = HippocampusApp.previewDocument()
    static let navigation = Navigation()
    static var previews: some View {
        RoleView(role: Structure.Role.note)
            .environmentObject(document)
            .environmentObject(navigation)
    }
}

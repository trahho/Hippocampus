//
//  QueryMapView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 12.05.23.
//

import Foundation
import SwiftUI

struct QueryMapView: View {
    @EnvironmentObject var navigation: Navigation
    @EnvironmentObject var document: Document
    @ObservedObject var query: Presentation.Query

    var graph: Presentation.PresentationResult.PresentationGraph {
        Presentation.PresentationResult.PresentationGraph(query: query, result: query.apply(to: document.information))
    }

    var body: some View {
        GraphView(graph: graph)
    }
}

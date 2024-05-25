//
//  CollectionView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.05.24.
//

import Foundation
import SwiftUI

struct CollectionView: View {
    @State var items: Set<Information.Item>
    @State var condition: Information.Condition
    @State var sequence: Presentation.Sequence
    @State var layout: Presentation.Layout

    var body: some View {
        EmptyView()
    }
}

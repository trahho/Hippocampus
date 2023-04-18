//
//  DetailView.swift
//  Hippocampus (macOS)
//
//  Created by Guido Kühn on 24.03.23.
//

import Foundation
import SwiftUI

struct DetailView: View {
    @EnvironmentObject var navigation: Navigation

    var body: some View {
        ZStack {
            if let detail = navigation.detail {
                detail.view
//                    .transition(.slide)
            } else {
                Text("Empty")
            }
        }
    }
}

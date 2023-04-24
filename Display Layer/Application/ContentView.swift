//
//  ContentView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.04.23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigation: Navigation
    
    var body: some View {
        if let query = navigation.query {
            QueryView(query: query)
        } else {
            EmptyView()
        }
    }
}

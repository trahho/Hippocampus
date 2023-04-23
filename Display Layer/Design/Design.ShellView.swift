//
//  Design.ShellView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 21.04.23.
//

import SwiftUI

struct Design_ShellView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
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

struct Design_ShellView_Previews: PreviewProvider {
    static var previews: some View {
        Design_ShellView()
    }
}

//
//  Design.GridForm.swift
//  Hippocampus
//
//  Created by Guido Kühn on 11.08.24.
//

import SwiftUI

struct Design_GridForm: View {
    @ViewBuilder var form: some View {
        Section{
            Section {
                TextField("Name", text: .constant("Kühn"))
            }
            TextField("Vorname", text: .constant("Guido"))
        }
    }

    var body: some View {
        Grid {
//            Group(subviews: form) { subviews in
//                Text("Anzahl: \(subviews.count)")
//                ForEach(0 ..< subviews.count, id:\.self) { subview in
//                    Text("\(subview)")
//                    subviews[subview]
//                }
//            }
        }
    }
}

#Preview {
    Design_GridForm()
}

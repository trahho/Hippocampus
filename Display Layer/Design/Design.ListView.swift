//
//  Design.ListView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.04.23.
//

import SwiftUI

struct Design_ListView: View {
    @State var selection: Int? = 2
    var body: some View {
//        List (selection: $selection){
        List {
            ForEach(1..<10) { number in
                DisclosureGroup {
                    ForEach(1..<10) { i in
                        Text("\(i)")
                            .font(.myText)
                                                    .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .listRowInsets(EdgeInsets())
                            .background(selection == i ? Color.blue.opacity(0.5).cornerRadius(8) : Color.clear.cornerRadius(0))
//                            .background {
//                                if i == selection {
//                                    RoundedRectangle(cornerRadius: 10, style: .circular)
//                                        .padding()
//                                        .foregroundColor(.red)
//                                }
//                            }
                    }
                } label: {
                    Text("\(number)")
                        .font(.myHeader)
                }

                .listRowSeparator(.hidden)
            }
        }
//        }
        .listStyle(.plain)
    }
}

struct Design_ListView_Previews: PreviewProvider {
    static var previews: some View {
        Design_ListView()
    }
}

////
////  Design.NestedListView.swift
////  Hippocampus
////
////  Created by Guido Kühn on 16.04.23.
////
//
//import SwiftUI
//
//
//
//struct Design_NestedListView: View {
//    var body: some View {
//        List {
//            Section ("AAa") {
//                NestedView()
//            }
//            Section ("BBB") {
//                NestedView()
//            }
//        }
//    }
//    
//    struct NestedView: View {
//        let strings = ["A", "B", "C"]
//        var body: some View {
//            Section("Bla") {
//            DisclosureGroup {
//                ForEach(strings, id: \.self) { s in
//                        Text(s)
//                    }
//            } label: {
//                Text("ABC")
//            }
//            }
//
//        }
//    }
//}
//
//struct Design_NestedListView_Previews: PreviewProvider {
//    static var previews: some View {
//        Design_NestedListView()
//    }
//}

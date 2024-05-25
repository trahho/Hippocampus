////
////  TextView.swift
////  Hippocampus (iOS)
////
////  Created by Guido Kühn on 11.03.23.
////
//
//import Foundation
//import SwiftUI
//
//struct TextView: View {
//    typealias Form = Structure.Aspect.Presentation.Form
//    
//    @ObservedObject var item: Information.Item
//    var aspect: Structure.Aspect
//    var form: String
//    var editable: Bool
//
//    var body: some View {
//        switch form {
//        case Form.icon:
//            Image(systemName: "text.quote")
//        default:
//            if editable {
//                TextField(aspect.name, text: Binding(get: { item[String.self, aspect] ?? "" }, set: { item[String.self, aspect] = $0 }))
//                    .textFieldStyle(.roundedBorder)
//            } else {
//                Text(item[String.self, aspect] ?? "")
//            }
//        }
//    }
//}

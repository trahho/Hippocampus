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
//    @ViewBuilder
//    var editView: some View {
//        if aspect.perspective.isStatic {
//            VStack(alignment: .leading) {
//                if let value = item[String.self, aspect], value != "" {
//                    Text(LocalizedStringKey(aspect.name))
//                        .font(.myLabel)
//                }
//                TextField(LocalizedStringKey(aspect.name), text: Binding(get: { item[String.self, aspect] ?? "" }, set: { item[String.self, aspect] = $0 }))
//                    .textFieldStyle(.roundedBorder)
//            }
//        } else {
//            VStack(alignment: .leading) {
//                if let value = item[String.self, aspect], value != "" {
//                    Text(LocalizedStringKey(aspect.name))
//                        .font(.myLabel)
//                }
//                TextField(aspect.name, text: Binding(get: { item[String.self, aspect] ?? "" }, set: { item[String.self, aspect] = $0 }))
//                    .textFieldStyle(.roundedBorder)
//            }
//        }
//    }
//
//    @ViewBuilder
//    var labelView: some View {
//        if let value = item[String.self, aspect] {
//            Text(value)
//        } else if aspect.perspective.isStatic {
//            Text(LocalizedStringKey(aspect.name))
//        } else {
//            Text(aspect.name)
//        }
//    }
//
//    var body: some View {
//        switch form {
//        case Form.icon:
//            Image(systemName: "text.quote")
//        case Form.firstParagraph:
//            let text = item[String.self, aspect] ?? ""
//            Text(text.prefix(while: { $0 != "\n" }))
//        case Form.edit:
//            editView
//        default:
//            if editable {
//                editView
//            } else {
//                labelView
//            }
//        }
//    }
//}

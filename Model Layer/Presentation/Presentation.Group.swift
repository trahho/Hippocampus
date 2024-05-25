////
////  Presentation.Group.swift
////  Hippocampus
////
////  Created by Guido Kühn on 23.04.23.
////
//
//import Foundation
//import SwiftUI
//import Smaug
//
//extension Presentation {
//    class Group: Object {
//        static let builtIn: Group = {
//            var result = Group()
//            result.id = UUID(uuidString: "0216B436-38D1-446D-884B-3D9662E6B345")!
//            result.name = "_builtIn"
//            result.queries = [.general, .notes, .topics]
//            return result
//        }()
//
//        @Property var name: String
//
//        @Relations(\Group.subGroups) var superGroups: Set<Group>
//        @Objects var subGroups: Set<Group>
//        @Objects var queries: Set<Query>
//
//        var isTop: Bool { superGroups.isEmpty }
//        
//        var allSuperGroups: Set<Group> {
//            let moreSuperGroups = superGroups.reduce(Set<Group>()) { partialResult, group in
//                partialResult.union(group.allSuperGroups)
//            }
//            return superGroups.union(moreSuperGroups)
//        }
//
//        @ViewBuilder
//        var textView: some View {
//            if isStatic {
//                Text(LocalizedStringKey(name))
//            } else {
//                Text(name)
//            }
//        }
//    }
//}

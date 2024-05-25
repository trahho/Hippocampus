////
////  Structure.Query.Predicate.Builder.swift
////  Hippocampus
////
////  Created by Guido Kühn on 27.12.22.
////
//
//import Foundation
//extension Presentation.Predicate {
//    @resultBuilder
//    enum Builder {
//        static func buildBlock() -> [Presentation.Predicate] { [] }
//
//        static func buildBlock(_ predicates: Presentation.Predicate...) -> [Presentation.Predicate] {
//            predicates
//        }
//    }
//
//    convenience init(_ roles: [Structure.Role], _ condition: Information.Condition) {
//        self.init()
//        self.condition = condition
//        self.roles = roles.asSet
//    }
//}
//
//extension Presentation.RoleRepresentation {
//    @resultBuilder
//    enum Builder {
//        static func buildBlock() -> [Presentation.RoleRepresentation] { [] }
//
//        static func buildBlock(_ predicates: Presentation.RoleRepresentation...) -> [Presentation.RoleRepresentation] {
//            predicates
//        }
//    }
//}
//
//extension Presentation.Query {
//    convenience init(_ id: String,
//                     _ name: String,
//                     @Presentation.Predicate.Builder predicates: () -> [Presentation.Predicate] = { [] },
//                     @Presentation.RoleRepresentation.Builder representations: () -> [Presentation.RoleRepresentation] = { [] })
//    {
//        self.init()
//        self.id = UUID(uuidString: id)!
//        self.name = name
//        let predicates = predicates()
//        self.predicates = predicates.asSet
//        let representations = representations()
//        roleRepresentations = representations.asSet
//    }
//}

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
//    convenience init(_ perspectives: [Structure.Perspective], _ condition: Information.Condition) {
//        self.init()
//        self.condition = condition
//        self.perspectives = perspectives.asSet
//    }
//}
//
//extension Presentation.PerspectiveRepresentation {
//    @resultBuilder
//    enum Builder {
//        static func buildBlock() -> [Presentation.PerspectiveRepresentation] { [] }
//
//        static func buildBlock(_ predicates: Presentation.PerspectiveRepresentation...) -> [Presentation.PerspectiveRepresentation] {
//            predicates
//        }
//    }
//}
//
//extension Presentation.Query {
//    convenience init(_ id: String,
//                     _ name: String,
//                     @Presentation.Predicate.Builder predicates: () -> [Presentation.Predicate] = { [] },
//                     @Presentation.PerspectiveRepresentation.Builder representations: () -> [Presentation.PerspectiveRepresentation] = { [] })
//    {
//        self.init()
//        self.id = UUID(uuidString: id)!
//        self.name = name
//        let predicates = predicates()
//        self.predicates = predicates.asSet
//        let representations = representations()
//        perspectiveRepresentations = representations.asSet
//    }
//}

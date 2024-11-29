////
////  Presentation.Query+statics.swift
////  Hippocampus
////
////  Created by Guido Kühn on 23.04.23.
////
//
//import Foundation
//
//extension Presentation.Query {
//    typealias Query = Presentation.Query
//    typealias Predicate = Presentation.Predicate
//    typealias Perspective = Structure.Perspective
//    typealias Form = Structure.Aspect.Presentation.Form
//    typealias PerspectiveRepresentation = Presentation.PerspectiveRepresentation
//
//    //        typealias Predicate = Presentation.Predicate
//    fileprivate enum Keys {
//        static let general = "2D7A4847-BE08-4987-8D19-039B3E3484A8"
//        static let notes = "89913172-022C-4EF0-95BA-76FF8E32F18B"
//        static let topics = "B7430903-0AC5-4C72-91E5-B54B73C8B5FD"
//    }
//
//    static let perspectiveRepresentations: [PerspectiveRepresentation] = [PerspectiveRepresentation(.global, "_Title")]
//
//    static let general = Query(Keys.general, "_General") {
//        Predicate([.global], .always(true))
//    }
//
//    static let notes = Query(Keys.notes, "_Notes") {
//        //            Predicate([.note, .topic], .hasPerspective(Perspective.note.id))
//        Predicate([.note], .hasPerspective(Perspective.note))
//    } representations: {
//        PerspectiveRepresentation(.topic, "_Title")
//        PerspectiveRepresentation(.drawing, "_Icon")
//        PerspectiveRepresentation(.drawing, "_Card")
//        PerspectiveRepresentation(.text, "_Introduction_Short")
//    }
//
//    static let topics = Query(Keys.topics, "_Topics") {
//        //            Predicate([.note, .topic], .hasPerspective(Perspective.note.id))
//        Predicate([.topic], .hasPerspective(Perspective.topic))
//    }
//}

//
//  Structure.Role+statics.swift
//  Hippocampus
//
//  Created by Guido Kühn on 07.04.23.
//

import Foundation
extension Structure.Role {
    typealias Role = Structure.Role
    typealias Aspect = Structure.Aspect
//    typealias Reference = Structure.Reference
//    typealias Form = Structure.Aspect.Presentation.Form
//    typealias Representation = Structure.Representation
    
    fileprivate enum Keys {
        static let same = "00000000-0000-0000-0000-000000000000"
        static let tracked = "D7812874-085B-4161-9ABB-C82D4A145634"
        static let named = "8A81358C-2A7C-497D-A93D-306F776C217C"
        static let trackedCreated = "E851210E-7CCC-4D09-87C1-A7E75E04D7F4"
        static let namedName = "6247260E-624C-48A1-985C-CDEDDFA5D3AD"
        static let hierarchical = "B6D7755C-210C-484D-B79B-ACD931D581C9"
        static let topic = "3B681E4A-C42A-48D5-92E2-93F4B5C7CDD0"
        static let text = "73874A60-423C-4128-9A5A-708D4350FEF3"
        static let textText = "F0C2B7D0-E71A-4296-9190-8EF2D540338F"
        static let note = "8AB172CF-2330-4861-B551-8728BA6062BF"
        static let noteHeadline = "B945443A-32D6-4FE7-A63F-65436CAAA3CA"
        static let miniMindMap = "8ECEA3AE-1E0B-4DDD-BABE-5836C577FE08"
        static let miniMindMapTopic = "873BD3D8-525C-45F1-8B66-74DB0F433BB5"
        static let miniMindMapAspect = "F5DC22EC-A54E-428E-8C2A-99A543521AA5"
    }
    
    static let same = Role(Keys.same, "")
    
    static let tracked = Role(Keys.tracked, "_Global") {
        Aspect(Keys.trackedCreated, "/Created", .date)
    }
    
    static let named = Role(Keys.named, "_Named") {
        Aspect(Keys.namedName, "/Name", .text)
    }
    
    static let text = Role(Keys.text, "_Text") {
        Aspect(Keys.textText, "/Text", .text)
    } presentations: {
        [
            .named("", .aspect(Keys.textText.uuid, appearance: .normal, editable: true))
        ]
    }
    
    static let drawing = Role(Keys.named, "_Drawing") {
        Aspect(Keys.namedName, "/Drawing", .drawing)
    }
    
    static let hierarchical = Role(Keys.hierarchical, "_Hierarchy") {} references: {
        Role.same
    }
    
    static let topic = Role(Keys.topic, "_Topic", [.hierarchical, .named, .tracked]) {} references: {
        Role.note
    }
    
    static let note = Role(Keys.note, "_Note", [.named, .tracked, .text, .drawing]) 
    
    // representations: {
    //        Representation("_Title", .aspect(Keys.globalName, form: Form.normal))
    //    }
    
//    static let drawing = Role(Keys.drawing, "_Drawing", addToMenu: true) {
//        Aspect(Keys.drawingDrawing, "/Drawing", .drawing)
//    }
    ////representations: {
    ////        Representation("_Icon", .aspect(Keys.drawingDrawing, form: Form.icon))
    ////        Representation("_Card", .aspect(Keys.drawingDrawing, form: Form.small))
    ////        Representation("_Canvas", .aspect(Keys.drawingDrawing, form: Form.normal))
    ////    }
    ////
//    static let text = Role(Keys.text, "_Text") {
//        Aspect(Keys.textText, "/Text", .text)
//    } representations: {
//        Representation("_Introduction_Short", .aspect(Keys.textText, form: Form.firstParagraph))
//    }
//
//    static let topic = Role(Keys.topic, "_Topic", [.global], addToMenu: true)
//
//    static let note = Role(Keys.note, "_Note", [.global, .drawing, .text], addToMenu: true) {
//        Aspect(Keys.noteHeadline, "/Headline", .text)
//    } representations: {
//        Representation("_Edit", .vertical(
//            .aspect(Keys.globalName, form: Form.edit),
//            .aspect(Keys.noteHeadline, form: Form.edit),
//            .aspect(Keys.textText, form: Form.edit)
//        ))
//    } associated: {
//        Reference(topic)
//    }
//
//    static let miniMindMap = Role(Keys.miniMindMap, "_MiniMindMap", [.global, .text]) {
//    } representations: {
//    }
//
    ////    static let miniMindMapTopic = Role(Keys.miniMindMapTopic, "_MiniMindMapTopic", [.miniMindMap]) {
//    } representations: {
//    } associated: {
//        Reference(miniMindMap)
//    }
//
//    static let miniMindMapTopic = Role(Keys.miniMindMapTopic, "_MiniMindMapAspect", [.miniMindMap]) {
//    } representations: {
//    } associated: {
//        Reference(miniMindMapTopic)
//    }
}

extension String {
    var uuid: UUID { UUID(uuidString: self)!}
}

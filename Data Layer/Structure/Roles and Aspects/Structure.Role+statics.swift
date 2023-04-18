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
    typealias Reference = Structure.Reference
    typealias Form = Structure.Aspect.Presentation.Form
    typealias Representation = Structure.Representation

    fileprivate enum Keys {
        static let global = "D7812874-085B-4161-9ABB-C82D4A145634"
        static let globalName = "8A81358C-2A7C-497D-A93D-306F776C217C"
        static let globalCreated = "E851210E-7CCC-4D09-87C1-A7E75E04D7F4"
        static let drawing = "6247260E-624C-48A1-985C-CDEDDFA5D3AD"
        static let drawingDrawing = "B6D7755C-210C-484D-B79B-ACD931D581C9"
        static let topic = "3B681E4A-C42A-48D5-92E2-93F4B5C7CDD0"
        static let text = "73874A60-423C-4128-9A5A-708D4350FEF3"
        static let textText = "F0C2B7D0-E71A-4296-9190-8EF2D540338F"
        static let note = "8AB172CF-2330-4861-B551-8728BA6062BF"
        static let noteHeadline = "B945443A-32D6-4FE7-A63F-65436CAAA3CA"
    }

    static let global = Role(Keys.global, "_Global") {
        Aspect(Keys.globalName, "/Name", .text)
        Aspect(Keys.globalCreated, "/Created", .date)
    } representations: {
        Representation("_Title", .aspect(Keys.globalName, form: Form.normal))
    }

    static let drawing = Role(Keys.drawing, "_Drawing", addToMenu: true) {
        Aspect(Keys.drawingDrawing, "/Drawing", .drawing)
    } representations: {
        Representation("_Icon", .aspect(Keys.drawingDrawing, form: Form.icon))
        Representation("_Card", .aspect(Keys.drawingDrawing, form: Form.small))
        Representation("_Canvas", .aspect(Keys.drawingDrawing, form: Form.normal))
    }

    static let text = Role(Keys.text, "_Text") {
        Aspect(Keys.textText, "/Text", .text)
    } representations: {
        Representation("_Introduction_Short", .aspect(Keys.textText, form: Form.firstParagraph))
    }

    static let topic = Role(Keys.topic, "_Topic", [.global], addToMenu: true)

    static let note = Role(Keys.note, "_Note", [.global, .drawing, .text], addToMenu: true) {
        Aspect(Keys.noteHeadline, "/Headline", .text)
    } representations: {
        Representation("_Edit", .vertical(
            .aspect(Keys.globalName, form: Form.edit),
            .aspect(Keys.noteHeadline, form: Form.edit),
            .aspect(Keys.textText, form: Form.edit)
        ))
    } associated: {
        Reference(topic)
    }
}

//
//  FilterEditView.SortingEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 22.07.24.
//

import Grisu
import SwiftUI

struct AspectSelector: View {
    // MARK: Properties

//    @Binding var aspectId: Structure.Aspect.ID
    @Binding var schräg: (aspect: Structure.Aspect.ID, form: Structure.Aspect.Kind.Form?)

    @Environment(\.document) private var document
    @State private var role: Structure.Role?

    // MARK: Computed Properties

    var roles: [Structure.Role] {
        document.structure.roles.filter { $0 != Structure.Role.Statics.same }.sorted { $0.description < $1.description }
    }

    var aspects: [Structure.Aspect] {
        role?.allAspects.sorted { $0.name < $1.name } ?? []
    }

    // MARK: Lifecycle

   

    // MARK: Content

    var body: some View {
        HStack {
            ValuePicker("", data: roles, selection: Binding(get: { role ?? aspect(id: schräg.aspect)?.role }, set: { role = $0 }), unkown: "unknown")
                .sensitive
            ValuePicker("", data: aspects, selection: Binding<Structure.Aspect?>(get: { aspect(id: schräg.aspect) }, set: { aspect in
                guard let aspect else { return }
                schräg.aspect = aspect.id
            }), unkown: "unknown")
                .sensitive
            if let aspect = aspect(id: schräg.aspect), let forms = aspect.kind.forms {
                ValuePicker("", data: forms, selection: Binding(get: { schräg.form }, set: { schräg.form = $0}), unkown: "unknown")
            }
            Spacer()
        }
    }

    // MARK: Functions

    func role(id: Structure.Role.ID) -> Structure.Role? {
        guard let role = document[Structure.Role.self, id] else { return nil }
        return role
    }

    func aspectName(id: Structure.Aspect.ID) -> String {
        guard let aspect = aspect(id: id) else { return "unknown" }
        return aspect.name
    }

    func aspect(id: Structure.Aspect.ID) -> Structure.Aspect? {
        guard let aspect = document[Structure.Aspect.self, id] else { return nil }
        return aspect
    }
}

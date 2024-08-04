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

    @Binding var aspectId: Structure.Aspect.ID

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
            ValuePicker("", data: roles, selection: Binding(get: { role ?? aspect(id: aspectId)?.role }, set: { role = $0 }), unkown: "unknown")
                .sensitive
            ValuePicker("", data: aspects, selection: Binding<Structure.Aspect?>(get: { aspect(id: aspectId) }, set: { aspect in
                guard let aspect else { return }
                aspectId = aspect.id
            }), unkown: "unknown")
                .sensitive
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

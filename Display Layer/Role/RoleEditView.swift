//
//  RoleEditView.swift
//  Hippocampus
//
//  Created by Guido Kühn on 18.06.24.
//

import Grisu
import SwiftUI

struct RoleEditView: View {
    @Environment(Document.self) var document
    @State var role: Structure.Role
    @State var expanded: SectionExpansions = .init()

    var conformation: [Structure.Role] {
        role.roles.sorted(by: { $0.name.localized($0.isStatic) < $1.name.localized($1.isStatic) })
    }

//    func sourceCode(_ aspect: Structure.Aspect) -> String {
//        """
//                {
//                    let aspect = Aspect(id: "\(aspect.id)".uuid)
//                    aspect.name = "\(aspect.name)"
//                    aspect.kind = .\(aspect.kind)
//                    aspect.computed = \(aspect.computed)
//                    return aspect
//                }()
//        """
//    }
//
//    func sourceCode(_ aspects: [Structure.Aspect]) -> String {
//        if !aspects.isEmpty {
//            """
//            [
//            \(role.aspects.map { sourceCode($0) }.joined(separator: ",\n"))
//                ]
//            """
//        } else { "" }
//    }
//
//    func sourceCode(_ particle: Structure.Particle) -> String {
//        """
//                {
//                    let particle = Particle(id: "\(particle.id)".uuid)
//                    particle.name = "\(particle.name)"
//                    return particle
//                }()
//        """
//    }
//
//    func sourceCode(_ particles: [Structure.Particle]) -> String {
//        if !particles.isEmpty {
//            """
//            role.particles = [
//            \(role.particles.map { sourceCode($0) }.joined(separator: ",\n"))
//                ]
//            """
//        } else { "" }
//    }
//
//    func sourceCode(_ roles: [Structure.Role]) -> String {
//        if !roles.isEmpty {
//            """
//            role.particles = [
//            \(role.particles.map { sourceCode($0) }.joined(separator: ",\n"))
//                ]
//            """
//        } else { "" }
//    }
//
//    var sourceCode: String {
//        let result =
//            """
//            static let \(role.name) = {
//                var role = Role(id: "\(role.id)".uuid)
//                role.name = "\(role.name)"
//                \(role.roles.isEmpty ? "" : "role.roles = [" + role.roles.map { "." + $0.name }.joined(separator: ", ") + "]")
//                role.references = [\(role.references.map { "." + $0.name }.joined(separator: ", "))]
//                \(role.aspects.isEmpty ? "" : "role.aspects = " + sourceCode(role.aspects))
//                return role
//            }()
//            """
//
//        return result
//    }

    var sc: String {
        var result = ""
        result += "static let \(role.name) = {"
        result += "\n\t" + "var role = Role(id: \"\(role.id)\".uuid)"
        result += "\n\t" + "role.name = \"\(role.name)\""
        if !role.roles.isEmpty {
            result += "\n\t" + "role.roles = [" +
                role.roles
                .map { ".\($0.name)" }
                .joined(separator: ", ") +
                "]"
        }
        if !role.aspects.isEmpty {
            result += "\n\t" + "role.aspects = ["
            for i in 0 ..< role.aspects.count {
                let aspect = role.aspects[i]
                if i > 0 { result += "," }
                result += "\n\t\t" + "{"
                result += "\n\t\t\t" + "let aspect = Aspect(id: \"\(aspect.id)\".uuid)"
                result += "\n\t\t\t" + "aspect.name = \"\(aspect.name)\""
                result += "\n\t\t\t" + "aspect.kind = .\(aspect.kind)"
                result += "\n\t\t\t" + "aspect.computed = \(aspect.computed)"
                result += "\n\t\t\t" + "return aspect"
                result += "\n\t\t" + "}()"
            }

            result += "\n\t" + "]"
        }

        result += "\n}()"
        return result
    }

    var body: some View {
        Form {
            Section("Title", isExpanded: $expanded) {
                Text("\(role.id)")
                    .font(.caption)
                TextField("Name", text: $role.name)
            }

//            Section("Conforms to", isExpanded: $expanded) {
//                List(conformation) { item in
//                    Text(item.name.localized(item.isStatic))
//                        .actions {
//                            Button {
//                                role.roles.remove(item: item)
//                            } label: {
//                                Label("Remove", systemImage: "minus.square")
//                            }
//                        }
//                }
//            }
            Section("Aspects", isExpanded: $expanded) {
                ListEditView($role.aspects) { aspect in
                    Text("\(aspect.id)")
                        .font(.caption)
                    TextField("Name", text: aspect.name)
                    EnumPicker("Kind", selection: aspect.kind)
                    Toggle("Computed", isOn: aspect.computed)
                } createItem: {
                    document(Structure.Aspect.self)
                } deleteItem: {
                    document.structure.delete($0)
                }
            }

            Section("Particles", isExpanded: $expanded) {
                ListEditView($role.particles) { particle in
                    Text("\(particle.id)")
                        .font(.caption)
                    TextField("Name", text: particle.name)
                    Section("Aspects") {
                        ListEditView(particle.aspects) { aspect in
                            Text("\(aspect.id)")
                                .font(.caption)
                            TextField("Name", text: aspect.name)
                            EnumPicker("Kind", selection: aspect.kind)
                            Toggle("Computed", isOn: aspect.computed)
                        } createItem: {
                            document(Structure.Aspect.self)
                        } deleteItem: {
                            document.structure.delete($0)
                        }
                    }
                } createItem: {
                    document(Structure.Particle.self)
                } deleteItem: {
                    document.structure.delete($0)
                }
            }

            Section("Source code", isExpanded: $expanded) {
                Text(sc)
                    .font(.caption)
                    .textSelection(.enabled)
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    @State var document = HippocampusApp.previewDocument()
    document.structure.roles.forEach { $0.toggleStatic() }
    return RoleEditView(role: Structure.Role.note)
        .environment(document)
}

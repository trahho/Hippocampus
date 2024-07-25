//
//  Structure.Aspect.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import Grisu
import Smaug
import SwiftUI

extension Structure {
    class Aspect: Structure.Object, EditableListItem, Pickable {
        // MARK: Properties

        @Relation(\Structure.Role.aspects) var role: Structure.Role?
        @Relation(\Structure.Particle.aspects) var particle: Structure.Particle?

        @Property var name: String = ""
        @Property var kind: Kind = .text
        @Property var computation: Information.Computation?
        @Property var modification: Information.Modification?
        @Property var presentation: [Presentation.Appearance] = [.normal, .icon]
        var codedComputation: CodedComputation?
        @Transient var exportCodedComputed = false

        // MARK: Computed Properties

        var description: String {
            name
        }

        var information: Information {
            store as! Information
        }
        
        var isComputed: Bool {
            codedComputation != nil || computation != nil
        }

        private var getAspect: (Aspect.ID) -> Aspect? { { self[Aspect.self, $0] }}

        // MARK: Functions

//        @Relation(\Role.aspects) var role: Role!

        subscript<T>(_: T.Type, _ item: Aspectable) -> T? where T: Information.Value {
            get { self[item]?.as(T.self) }
            set { self[item] = Value(newValue) }
        }

        subscript(_ item: Aspectable) -> Value? {
            get {
                if let codedComputation {
                    return codedComputation.get(item, self)
                } else if let computation, let structure = store as? Structure {
                    return computation.compute(for: item, structure: structure)
                } else {
                    return item[id]
                }
            }
            set {
                if let codedComputation {
                    codedComputation.set?(item, newValue, self)
                } else if let modification, let structure = store as? Structure {
                    modification.modify(item, structure: structure)
                } else { item[id] = newValue }
            }
        }
    }
}

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
        var description: String {
            name
        }

        @Relation(\Structure.Role.aspects) var role: Structure.Role!
        @Property var name: String = ""
        @Property var kind: Kind = .text
        @Property var computed = false
        @Property var computation: Information.Computation?
        @Property var presentation: [Presentation.Appearance] = [.normal, .icon]

        var information: Information {
            store as! Information
        }

        private var getAspect: (Aspect.ID) -> Aspect? { { self[Aspect.self, $0] }}

//        @Relation(\Role.aspects) var role: Role!

        subscript<T>(_ type: T.Type, _ item: Information.Item) -> T? where T: Information.Value {
            get { self[item]?.value as? T }
            set { self[item] = Information.ValueStorage(newValue) }
        }

        subscript(_ item: Information.Item) -> Information.ValueStorage? {
            get {
                if let computation { computation.compute(for: item, getAspect: getAspect) } else { item[id] }
            }
            set {
                guard !computed else { return }
                item[id] = newValue
            }
        }

        subscript<T>(_ type: T.Type, _ item: Information.Particle) -> T? where T: Information.Value {
            get { self[item]?.value as? T }
            set { self[item] = Information.ValueStorage(newValue) }
        }

        subscript(_ item: Information.Particle) -> Information.ValueStorage? {
            get {
                if let computation { computation.compute(for: item, getAspect: getAspect) } else { item[id] }
            }
            set {
                guard !computed else { return }
                item[id] = newValue
            }
        }
    }
}

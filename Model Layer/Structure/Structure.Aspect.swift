//
//  Structure.Aspect.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import Smaug
import SwiftUI

extension Structure {
    class Aspect: Object {
        @Property var name: String = ""
        @Property var kind: Kind = .text
        @Property var index = 0
        @Property var computed = false
        
        @Relation(\Role.aspects) var role: Role!

        subscript<T>(_ type: T.Type, _ item: Information.Item) -> T? where T: Information.Item.Value {
            get {
                computed ? nil : item[T.self, self]
            }
            set {
                guard !computed else { return }
                item[T.self, self] = newValue
            }
        }
    }
}

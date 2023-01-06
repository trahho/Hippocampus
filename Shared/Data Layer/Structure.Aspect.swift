//
//  Structure.Aspect.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import SwiftUI

extension Structure {
    class Aspect: Object {
        enum Representation: PersistentValue {
            case text, drawing, date
        }

        @Persistent var name: String = ""
        @Persistent var representation: Representation
//        @Persistent var defaultValue: (any PersistentValue)?

        @Relation(inverse: "aspects") var role: Role!
    }
}

extension Structure.Aspect {
    @ViewBuilder
    func view(for item: Information.Item, editable: Bool) -> some View {
        switch self.representation {
        case .text:
            TextView(item: item, aspect: self, editable: editable)
        case .drawing:
            EmptyView()
        case .date:
            EmptyView()
        }
    }

    struct TextView: View {
        @ObservedObject var item: Information.Item
        var aspect: Structure.Aspect
        var editable: Bool

        var body: some View {
            if editable {
                TextField(aspect.name, text: Binding(get: { item[String.self, aspect] ?? "" }, set: {
                    item[String.self, aspect] = $0 }))
            } else {
                Text(item[String.self, aspect] ?? "")
            }
        }
    }
}

//extension Structure.Aspect {
//    func below(_ value: String) -> Mind.Opinion.AspectValueComparison {
//        Mind.Opinion.AspectValueComparison(aspect: self, comparison: .below, value: .string(value))
//    }
//
//    func below(_ value: Date) -> Mind.Opinion.AspectValueComparison {
//        Mind.Opinion.AspectValueComparison(aspect: self, comparison: .below, value: .date(value))
//    }
//
//    func below(_ value: Int) -> Mind.Opinion.AspectValueComparison {
//        Mind.Opinion.AspectValueComparison(aspect: self, comparison: .below, value: .int(value))
//    }
//
//    func above(_ value: String) -> Mind.Opinion.AspectValueComparison {
//        Mind.Opinion.AspectValueComparison(aspect: self, comparison: .above, value: .string(value))
//    }
//
//    func above(_ value: Date) -> Mind.Opinion.AspectValueComparison {
//        Mind.Opinion.AspectValueComparison(aspect: self, comparison: .above, value: .date(value))
//    }
//
//    func above(_ value: Int) -> Mind.Opinion.AspectValueComparison {
//        Mind.Opinion.AspectValueComparison(aspect: self, comparison: .above, value: .int(value))
//    }
//
//    //    func isEqual<T: ComparableCodable>(_ value: T) -> Mind.Opinion.AspectValueComparison<T> {
//    //        Mind.Opinion.AspectValueComparison<T>(aspect: self, comparison: .equal, value: value)
//    //    }
//    //
//    //    func isUnequal<T: ComparableCodable>(_ value: T) -> Mind.Opinion.AspectValueComparison<T> {
//    //        Mind.Opinion.AspectValueComparison<T>(aspect: self, comparison: .unequal, value: value)
//    //    }
//}
//
//extension Bool: Comparable {
//    public static func < (lhs: Bool, rhs: Bool) -> Bool {
//        !lhs && rhs
//    }
//}

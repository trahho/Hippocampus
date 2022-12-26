////
////  PersistentGraph.Predicate+Basics.swift
////  Hippocampus
////
////  Created by Guido Kühn on 25.12.22.
////
//
//import Foundation
//
//extension PersistentGraph.Predicate {
//    class Static: PersistentGraph.Predicate {
//        static func == (lhs: Static, rhs: Static) -> Bool {
//            lhs.literal == rhs.literal
//        }
//        
//        @Serialized var literal: Bool = false
//        
//        required init() {}
//        
//        init(literal: Bool) {
//            super.init()
//            self.literal = literal
//        }
//
//        override func matches(for member: PersistentGraph.Member) -> Bool {
//            literal
//        }
//    }
//    
//    class HasRolePredicate: PersistentGraph.Predicate {
//        static func == (lhs: HasRolePredicate, rhs: HasRolePredicate) -> Bool {
//            lhs.role == rhs.role
//        }
//        
//        @Serialized var role: Role
//        
//        required init() {}
//
//        init(role: Role) {
//            super.init()
//            self.role = role
//        }
//        
//        override func matches(for member: PersistentGraph.Member) -> Bool {
//            member[role: role]
//        }
//    }
//    
//    class HasValue<T>: PersistentGraph.Predicate where T: PersistentGraph.PersistentValue & Comparable {
//        enum Comparison {
//            case below, above, equal, unequal
//            
//            func compare(_ a: T?, _ b: T?) -> Bool {
//                switch self {
//                case .below:
//                    return a != nil && (b == nil || a! < b!)
//                case .above:
//                    return b != nil && (a == nil || a! > b!)
//                case .equal:
//                    return a == b
//                case .unequal:
//                    return a != b
//                }
//            }
//        }
//        
//        static func == (lhs: HasValue, rhs: HasValue) -> Bool {
//            lhs.key == rhs.key && lhs.value == rhs.value && lhs.comparison == rhs.comparison
//        }
//        
//        @Serialized var key: Key
//        @Serialized var value: T?
//        @Serialized var comparison: Comparison
//        
//        required init() {}
//        
//        init(key: Key, value: T?, comparison: Comparison) {
//            super.init()
//            self.key = key
//            self.value = value
//            self.comparison = comparison
//        }
//        
//        override func matches(for member: PersistentGraph.Member) -> Bool {
//            comparison.compare(member[T.self, key], value)
//        }
//    }
//}

//
//  ValueStorage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.05.24.
//

import Foundation

extension Information.TimedValue {
    indirect enum ValueStorage: Codable & Equatable & Comparable & Hashable {
        static func < (lhs: ValueStorage, rhs: ValueStorage) -> Bool {
            guard let lhsValue = lhs.value as? (any Comparable), let rhsValue = rhs.value as? (any Comparable) else { return false}
            return lhsValue.isBelow(rhsValue)
        }
        
        typealias PersistentValue = Codable & Equatable
        
        case `nil`
        case a(Int)
        case b(Bool)
        case c(String)
        case d(Date)
        case g(UUID)
        
        public init?(_ value: (any PersistentValue)?) {
            if value == nil { return nil }
            else if let value = value as? Int { self = .a(value) }
            else if let value = value as? Bool { self = .b(value) }
            else if let value = value as? String { self = .c(value) }
            else if let value = value as? Date { self = .d(value) }
            
            else if let value = value as? UUID { self = .g(value) }
            //        else { return nil }
            else { fatalError("Storage for \(value?.typeName ?? "Hä?") not available") }
        }
        
        public var value: (any PersistentValue)? {
            switch self {
            case .nil: return nil
            case let .a(value): return value
            case let .b(value): return value
            case let .c(value): return value
            case let .d(value): return value
            case let .g(value): return value
            }
        }
    }
}

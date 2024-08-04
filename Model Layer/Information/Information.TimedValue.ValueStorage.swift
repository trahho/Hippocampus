//
//  ValueStorage.swift
//  Hippocampus
//
//  Created by Guido Kühn on 23.05.24.
//

import Foundation

extension Information.TimedValue {
    indirect enum ValueStorage: Codable & Equatable & Comparable & Hashable & SourceCodeGenerator {
        case `nil`
        case a(Int)
        case b(Bool)
        case c(String)
        case d(Date)
        case g(UUID)

        // MARK: Nested Types

        typealias PersistentValue = Codable & Equatable

        // MARK: Computed Properties

        public var value: (any PersistentValue)? {
            switch self {
            case .nil: nil
            case let .a(value): value
            case let .b(value): value
            case let .c(value): value
            case let .d(value): value
            case let .g(value): value
            }
        }

        // MARK: Lifecycle

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

        // MARK: Static Functions

        static func == (lhs: ValueStorage, rhs: ValueStorage) -> Bool {
//            guard let lhsValue = lhs.value as? (any Equatable), let rhsValue = rhs.value as? (any Equatable) else { return false }
            return isEqual(lhs.value, rhs.value)
        }

        static func < (lhs: ValueStorage, rhs: ValueStorage) -> Bool {
            guard let lhsValue = lhs.value as? (any Comparable), let rhsValue = rhs.value as? (any Comparable) else { return false }
            return isBelow(lhsValue, rhsValue)
//            return lhsValue.isBelow(rhsValue)
        }

        // MARK: Functions

        func sourceCode(tab _: Int, inline _: Bool, document _: Document) -> String {
            switch self {
            case .nil: ".nil"
            case let .a(value): ".init(\(value))!"
            case let .b(value): ".init(\(value))!"
            case let .c(value): ".init(\"\(value)\")!"
            case let .d(value): ".init(Date(\"\(value)\"))!"
            case let .g(value): ".init(\"\(value)\".uuid)!"
            }
        }
    }
}

extension Date {
    init(_ dateString: String, dateFormat: String? = nil) {
        let formatter = DateFormatter()
        if let dateFormat {
            formatter.dateFormat = dateFormat
        } else {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        self = formatter.date(from: dateString)!
    }
}

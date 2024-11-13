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
        case b(v: Bool)
        case d(v: Date)
        case i(v: Int)
        case n(v: Double)
        case s(v: String)
        case u(v: UUID)

        // MARK: Nested Types

        typealias PersistentValue = Codable & Equatable

        // MARK: Computed Properties

        public var value: (any PersistentValue)? {
            switch self {
            case .nil: nil
            case let .b(value): value
            case let .d(value): value
            case let .i(value): value
            case let .n(value): value
            case let .s(value): value
            case let .u(value): value
            }
        }

        // MARK: Lifecycle

        public init?(_ value: (any PersistentValue)?) {
            if value == nil { return nil }
            else if let value = value as? Bool { self = .b(v: value) }
            else if let value = value as? Date { self = .d(v: value) }
            else if let value = value as? Int { self = .i(v: value) }
            else if let value = value as? Double { self = .n(v: value) }
            else if let value = value as? String { self = .s(v: value) }
            else if let value = value as? UUID { self = .u(v: value) }
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
            case let .b(value): ".init(\(value))!"
            case let .d(value): ".init(Date(\"\(value)\"))!"
            case let .i(value): ".init(\(value))!"
            case let .n(value): ".init(\(value))!"
            case let .s(value): ".init(\"\(value)\")!"
            case let .u(value): ".init(\"\(value)\".uuid)!"
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

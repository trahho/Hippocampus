//
//  PersistentContent.swift
//  Hippocampus
//
//  Created by Guido Kühn on 02.12.22.
//

import Combine
import Foundation

protocol PersistentContent: DidChangeNotifier {
    func restore()
    func merge(other: Self) throws
    func encode() -> Data?
    static func decode(persistentData: Data) -> Self?
}

extension PersistentContent where Self: Serializable {
    func encode() -> Data? {
        guard let flattened = try? CyclicEncoder().flatten(self),
              let data = try? JSONEncoder().encode(flattened),
              let compressedData = try? (data as NSData).compressed(using: .lzfse) as Data
        else { return nil }

        return compressedData
    }

    static func decode(persistentData: Data) -> Self? {
        guard let data = try? (persistentData as NSData).decompressed(using: .lzfse) as Data,
              let flattened = try? JSONDecoder().decode(FlattenedContainer.self, from: data),
              let newContent = try? CyclicDecoder().decode(Self.self, from: flattened)
        else { return nil }
        return newContent
    }
}

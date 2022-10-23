//
//  Visualisation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 29.09.22.
//

import Foundation
import SwiftUI

// extension Visualisation {
//    @dynamicMemberLookup
//    class Genes: PersistentObject, ObservableObject {
//
//        struct NotFoundError: Error {
//            let key: String
//        }
//
//        static let genes: Genes = {
//            let result = Genes()
//            result.intensity = Intensity.normal
//            return result
//        }()
//
//        @PublishedSerialized var dna: [String: Codable] = [:]
//
//        func getValue<T>(for key: String) -> T? {
//            if let value = dna[key] as? T {
//                return value
//            } else if let superVisor, let value: T = superVisor.getValue(for: key) {
//                return value
//            } else {
//                return Visualisation.genes.getValue(for: key)
//            }
//        }
//
//        func setValue(_ value: Codable, for key: String) {
//            dna[key] = value
//        }
//
//        subscript<T>(dynamicMember dynamicMember: String) -> T where T: Codable {
//            get { getValue(for: dynamicMember) }
//            set { setValue(newValue, for: dynamicMember) }
//        }
//    }
// }

extension Genes {
    struct NotFoundError: Error {
        let key: String
    }
}

extension Genes {
    final class DNA: Serializable, ObservableObject {
        @PublishedSerialized var strength: Sensation.ReceptionStrength?
    }
}

@dynamicMemberLookup
class Genes: PersistentObject, ObservableObject {
    static let genes: Genes = {
        let result = Genes()
        result.strength = .normal
        return result
    }()

//    @PublishedSerialized var dna: [String: Codable] = [:]
    @PublishedSerialized var dna: DNA = .init()
    //    @Serialized var details: [Mind.Thing.ID: Genes] = [:]

    @Serialized var ancestor: Genes?

    subscript<T>(dynamicMember keyPath: WritableKeyPath<DNA, T?>) -> T? where T: Codable {
        get {
            if let value = dna[keyPath: keyPath] {
                return value
            } else if let ancestor, let value = ancestor[dynamicMember: keyPath] {
                return value
            } else if let value = Genes.genes[dynamicMember: keyPath] {
                return value
            }
            return nil
        }
        set {
            dna[keyPath: keyPath] = newValue
        }
    }

//    func getValue<T>(for key: String) -> T? {
//        if let value = dna[key] as? T {
//            return value
//        } else if let superVisor, let value: T = superVisor.getValue(for: key) {
//            return value
//        } else if let value: T = Genes.genes.getValue(for: key) {
//            return value
//        } else {
//            return nil
//        }
//    }

//    func setValue(_ value: Codable, for key: String) {
//        dna[key] = value
//    }

//    subscript<T>(dynamicMember dynamicMember: String) -> T? where T: Codable {
//        get { getValue(for: dynamicMember) }
//        set { setValue(newValue, for: dynamicMember) }
//    }

    //    func recover() {
    //        details.values.forEach { $0.superVisor = self }
    //    }
}

// extension Color: Codable {
//    enum CodingKeys: String, CodingKey {
//        case red, green, blue, opacity
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let r = try container.decode(Double.self, forKey: .red)
//        let g = try container.decode(Double.self, forKey: .green)
//        let b = try container.decode(Double.self, forKey: .blue)
//        let o = try container.decode(Double.self, forKey: .opacity)
//
//        self.init(red: r, green: g, blue: b)
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        guard let colorComponents = self.colorComponents else {
//            return
//        }
//
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(colorComponents.red, forKey: .red)
//        try container.encode(colorComponents.green, forKey: .green)
//        try container.encode(colorComponents.blue, forKey: .blue)
//        try container.encode(colorComponents., forKey: .opacity)
//    }
// }

// extension Visualisation {
//    var intensity: Senses.Intensity {
//        get { palette["intensity"] as? Senses.Intensity ?? Senses.Intensity.normal }
//        set { palette["intensity"] = newValue as! any Codable }
//    }
// }

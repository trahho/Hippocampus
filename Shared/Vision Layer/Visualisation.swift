//
//  Visualisation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 29.09.22.
//

import Foundation
import SwiftUI

@dynamicMemberLookup
class Visualisation: PersistentObject, ObservableObject {
    
    static let genes: Visualisation = {
        let result = Visualisation()
        return result
    }()
    
    @PublishedSerialized var dna: [String: Codable] = [:]

    var superVisor: Visualisation?

    func getValue<T>(for key: String) -> T? {
        if let value = dna[key] as? T {
            return value
        } else if let superVisor, let value: T = superVisor.getValue(for: key) {
            return value
        }
        return nil
    }

    func setValue(_ value: Codable, for key: String) {
        dna[key] = value
    }

    subscript<T>(dynamicMember dynamicMember: String) -> T? where T: Codable {
        get { getValue(for: dynamicMember) }
        set { setValue(newValue, for: dynamicMember) }
    }
}

//extension Color: Codable {
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
//}

// extension Visualisation {
//    var intensity: Senses.Intensity {
//        get { palette["intensity"] as? Senses.Intensity ?? Senses.Intensity.normal }
//        set { palette["intensity"] = newValue as! any Codable }
//    }
// }

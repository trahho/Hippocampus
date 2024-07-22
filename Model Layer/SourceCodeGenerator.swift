//
//  SourceCodeGenerator.swift
//  Hippocampus
//
//  Created by Guido Kühn on 14.07.24.
//

protocol SourceCodeGenerator {
    func sourceCode(tab i: Int, inline: Bool, document: Document) -> String
}

extension SourceCodeGenerator {
    var cr: String { "\n" }
    var tab: (Int) -> String {
        { "\n" + String(repeating: "\t", count: $0) }
    }
}

extension String {
    var sourceCode: String {
        let parts = self.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ")
        guard let first = parts.first  else { return self }
        let rest = parts.dropFirst()
        return first.lowercased() + rest.map { $0.uppercased() }.reduce("", +)
    }
}

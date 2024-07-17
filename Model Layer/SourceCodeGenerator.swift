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

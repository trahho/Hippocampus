//
//  Structure.Filter+sourceCode.swift
//  Hippocampus
//
//  Created by Guido Kühn on 10.07.24.
//

import Foundation

extension Structure.Filter: SourceCodeGenerator {
    func sourceCode(tab i: Int, inline _: Bool, document: Document) -> String {
        tab(i) + "static var \(name.sourceCode): Filter {"
            + tab(i + 1) + "let filter = Filter(id: \"\(id)\".uuid)"
            + tab(i + 1) + "filter.name = \"\(name)\""
            + superFiltersSourceCode(tab: i + 1)
            + tab(i + 1) + "filter.perspectives = [" + perspectives.map { "Structure.Perspective.Statics." + $0.name.sourceCode }.joined(separator: ", ") + "]"
            + tab(i + 1) + layoutsSourceCode(tab: i + 1, document: document)
            + tab(i + 1) + "filter.condition = " + condition.sourceCode(tab: i + 2, inline: true, document: document)
            + ordersSourceCode(tab: i + 1, document: document)
            + representationsSourceCode(tab: i + 1, document: document)
            + tab(i + 1) + "return filter"
            + tab(i) + "}"
    }

    fileprivate func layoutsSourceCode(tab i: Int, document _: Document) -> String {
        if layouts.isEmpty { "" } else {
            tab(i) + "filter.layouts = [" + layouts.map { "." + $0.description }.joined(separator: ", ") + "]"
                + tab(i) + "filter.layout = ." + (layout?.description ?? layouts.first!.description)
        }
    }

    fileprivate func representationsSourceCode(tab i: Int, document: Document) -> String {
        if representations.isEmpty { "" } else {
            tab(i) + "filter.representations = ["
                + representations
                .map {
                    tab(i + 1) + "{"
                        + tab(i + 2) + "let representation = Representation()"
                        + tab(i + 2) + "representation.condition = " + $0.condition.sourceCode(tab: i + 3, inline: true, document: document)
                        + tab(i + 2) + "representation.presentation = " + $0.presentation.sourceCode(tab: i + 3, inline: true, document: document)
                        + tab(i + 2) + "return representation"
                        + tab(i + 1) + "}()"
                        + tab(i + 1) + "]"
                }
                .joined(separator: ",")
        }
    }

    fileprivate func ordersSourceCode(tab i: Int, document: Document) -> String {
        if orders.isEmpty { "" } else {
            tab(i) + "filter.orders = ["
                + orders
                .map {
                    $0.sourceCode(tab: i + 1, inline: false, document: document)
                }
                .joined(separator: ", ")
                + "]"
                + tab(i) + "filter.orderIndex = \(orderIndex ?? 0)"
        }
    }

    fileprivate func superFiltersSourceCode(tab i: Int) -> String {
        if superFilters.isEmpty { "" } else {
            tab(i) + "filter.superFilters = ["
                + superFilters
                .map { "\($0.name.sourceCode)" }
                .joined(separator: ", ")
                + "]"
        }
    }
}

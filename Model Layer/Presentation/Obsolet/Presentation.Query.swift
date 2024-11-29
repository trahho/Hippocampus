////
////  Structure.Query.swift
////  Hippocampus
////
////  Created by Guido Kühn on 26.12.22.
////
//
//import Foundation
//import Smaug
//
//extension Presentation {
//    struct ItemDetail: Hashable {
//        let id = UUID()
//        let item: Information.Item
//        let perspectives: [Structure.Perspective]
//
//        var name: String {
//            item[String.self, Structure.Perspective.global.name] ?? ""
//        }
//
//        func hash(into hasher: inout Hasher) {
//            hasher.combine(id)
//        }
//    }
//
//    class Query: Object {
//        @Property var name: String
//        @Relations(\Group.queries) var groups: Set<Group>
//
//        var isTop: Bool { groups.isEmpty }
//
//        @Objects var predicates: Set<Predicate>
//        @Objects var perspectiveRepresentations: Set<PerspectiveRepresentation>
//        @PublishedSerialized var layout: Presentation.Layout = .map
//        @Published var items: [ItemDetail] = []
//        @Relations(\PresentationResult.Result.query) var results: Set<PresentationResult.Result>
//
//        func getRepresentation(_: any Sequence<PerspectiveRepresentation>, for perspective: Structure.Perspective) -> PerspectiveRepresentation?
//        {
//            let specific = perspectiveRepresentations
//                .filter { $0.perspective == perspective } // && $0.layouts.contains(layout) }
//                .first
//            let general = perspectiveRepresentations
//                .filter { $0.perspective == perspective } // && $0.layouts.isEmpty }
//                .first
//            return specific ?? general
//        }
//
//        static let defaultRepresentation = Structure.Presentation.aspect(Structure.Perspective.global.name, form: Form.normal)
//
//        func perspectiveRepresentation(perspective: Structure.Perspective, layout _: Presentation.Layout) -> PerspectiveRepresentation? {
//            getRepresentation(perspectiveRepresentations, for: perspective) ?? getRepresentation(Self.perspectiveRepresentations, for: perspective)
//        }
//
//        func apply(to information: Information) -> PresentationResult.Result {
//            let result = PresentationResult.Result()
////            results.insert(result)
//            for item in information.items {
//                analyze(item: item, in: information, for: result)
//            }
//            result.items.forEach { item in
//                item.next = result.items.filter { item.item.to.contains($0.item) }.asSet
//            }
//            return result
//        }
//
//        func analyze(_ item: Information.Item) -> Set<Structure.Perspective>? {
//            var result = Set<Structure.Perspective>()
//            var matches = false
//
//            for predicate in predicates {
//                if predicate.matches(for: item) {
//                    matches = true
//                    result.formUnion(predicate.perspectives)
//                }
//            }
//
//            return matches ? result : nil
//        }
//
//        func analyze(_ item: PresentationResult.Item) -> Set<Structure.Perspective>? {
//            analyze(item.item)
//        }
//
//        func analyze(item: Information.Item, in _: Information, for result: PresentationResult.Result) {
//            guard !result.items.contains(where: { $0.item == item }) else { return }
////            print("Analyze \(item[String.self, Structure.Perspective.global.name] ?? "Nix")")
//            let perspectives = analyze(item)
//            if let perspectives {
//                let resultItem = PresentationResult.Item(item: item, perspectives: perspectives)
//                result.items.insert(resultItem)
//            }
//        }
//
////        func analyze(edge: Information.Item, in information: Information, for result: PresentationResult.Result) {
//        ////            guard result.edgeStorage[edge.id] == nil else { return }
//        ////            analyze(node: edge.to.first!, in: information, for: result)
//        ////            guard let from = result.nodeStorage[edge.from.id], let to = result.nodeStorage[edge.to.id] else { return }
//        ////            let perspectives = analyze(edge)
//        ////            let item = Result.Edge(edge: edge, perspectives: perspectives ?? [], from: from, to: to)
//        ////            result.edgeStorage[edge.id] = item
////        }
//    }
//}

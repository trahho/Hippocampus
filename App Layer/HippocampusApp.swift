//
//  HippocampusApp.swift
//  Shared
//
//  Created by Guido Kühn on 29.07.22.
//

import SwiftUI

@main
struct HippocampusApp {
    // MARK: Static Properties

    static let memoryExtension = ".memory"
    static let persistentExtension = ".persistent"

    static var emptyDocument: Document = {
        let containerURL = URL.virtual
//            let url = containerURL.appendingPathComponent("Empty\(HippocampusApp.memoryExtension)")
        let result = Document(url: URL.virtual)
        return result
    }()

    // MARK: Static Computed Properties

    static var iCloudContainerUrl: URL { URL.iCloudDirectory.appendingPathComponent("Documents") }
    static var localContainerUrl: URL { URL.localDirectory.appendingPathComponent("Hippocampus") }

    // MARK: Properties

    @Environment(\.openWindow) var openWindow

//        var document: Document = previewDocument
//    var document: Document = .init(name: "Test", local: false)
        var document: Document = emptyDocument
}

// MARK: Static Properties

//    struct TestView: View {
//        var body: some View {
//            Text("\(HippocampusApp.locationService.authorization.rawValue)")
//        }
//    }

//
////    static let locationService = LocationService()
//
//    static var previewDocument: Document = {
//        let containerURL = URL.virtual
//        let url = containerURL.appendingPathComponent("Preview\(HippocampusApp.memoryExtension)")
//        let document = Document(url: url)
//
//        let aspect: Structure.Aspect = document[Structure.Aspect.self, "6247260E-624C-48A1-985C-CDEDDFA5D3AD".uuid]!
//
//        for i in 1 ..< 3 {
//            let filter = document(Structure.Filter.self)
//
//            filter.name = "Group \(i)"
//            filter.layouts = [.list]
//            filter.layout = .list
//            filter.roles = [Structure.Role.Statics.note]
//            for j in 1 ..< 4 {
//                let subFilter = document(Structure.Filter.self)
//                document[] = subFilter
//                subFilter.superFilters.append(filter)
////                subFilter.roots = !.role(Structure.Role.topic.id)<~
//                subFilter.layouts = [.tree, .list]
//                subFilter.layout = .tree
//                subFilter.name = "Filter \(j)"
//                subFilter.roles = [Structure.Role.Statics.topic, Structure.Role.Statics.note]
//            }
//        }
//
//        for filter in document.structure.filters.filter({ !$0.isStatic }) {
//            filter.orders = [.sorted(aspect.id, ascending: true)]
//            filter.order = filter.orders.first!
//            filter.condition = .role(Structure.Role.Statics.tracked.id)
////            filter.leafs = .always(true)
//        }
//
//        for i in 0 ..< 10 {
//            let other = document(Information.Item.self)
//            aspect[String.self, other] = "Hallo Welt🤩"
//            other.roles.append(Structure.Role.Statics.note)
//
//            let item = document(Information.Item.self)
//            aspect[String.self, item] = "\(i + 1). Hallo Welt🤩"
////            item.roles.append(Structure.Role.named)
//            item.roles.append(Structure.Role.Statics.topic)
//            for j in 0 ..< 5 {
//                let subItem = document(Information.Item.self)
//                aspect[String.self, subItem] = "\(i + 1).\(j + 1). Hallo Welt🤩"
////                subItem.roles.append(Structure.Role.named)
//                subItem.roles.append(Structure.Role.Statics.topic)
//                subItem.roles.append(Structure.Role.Statics.note)
//
//                subItem.from.append(item)
//                for k in 0 ..< 5 {
//                    let subsubItem = document(Information.Item.self)
//                    aspect[String.self, subsubItem] = "\(i + 1).\(j + 1).\(k + 1). Hallo Welt🤩"
//                    subsubItem.roles.append(Structure.Role.Statics.note)
////                    subsubItem.roles.append(Structure.Role.topic)
//
//                    subItem.to.append(subsubItem)
//                    subsubItem.from.append(item)
//                    let other = document(Information.Item.self)
//                    aspect[String.self, other] = "Hallo Welt🤩"
//                }
//            }
//        }
//
//        return document
//    }()
//

//
//    // MARK: Static Computed Properties
//

//
//    // MARK: Properties
//

//
//    // MARK: Static Functions
//
//    //        .preview1
////
////        inPreview ? Self.previewDocument() : .init(name: "Test", local: false)
//
////    @StateObject var navigation = Navigation()
//
////    static var graph: AnchorGraph = {
////        let result = AnchorGraph()
////        let a = AnchorGraph.Node()
////        let b = AnchorGraph.Node()
////        let c = AnchorGraph.Node()
////        result.nodes.append(a)
////        result.nodes.append(b)
////        result.nodes.append(c)
////        result.nodes.append( AnchorGraph.Edge(node: a, otherNode: b))
////        result.nodes.append( AnchorGraph.Edge(node: b, otherNode: c))
////        result.nodes.append( AnchorGraph.Edge(node: c, otherNode: a))
////
////        return result
////    }()
//
////    let navigation = Navigation()
//
//    static func documentURL(name: String, local: Bool) -> URL {
//        let containerURL = local ? HippocampusApp.localContainerUrl : HippocampusApp.iCloudContainerUrl
//        let result = containerURL.appendingPathComponent("\(name)\(HippocampusApp.memoryExtension)")
//        return result
//    }
// }
//
//// extension View {
////    func setDocument(_ document: Document) -> some View {
////        environment(document)
////            .environment(document.structure)
////            .environment(document.information)
////    }
//// }

extension EnvironmentValues {
    @Entry var navigation: Navigation = .init()
    @Entry var document: Document = HippocampusApp.emptyDocument

    var information: Information { document.information }
    var structure: Structure { document.structure }
}

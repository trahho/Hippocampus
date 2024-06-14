//
//  Arrangement.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.01.23.
//

import Foundation
import SwiftUI

indirect enum Presentation: Structure.PersistentValue {
  

    enum Appearance: Structure.PersistentValue {
        case icon, small, full, normal, line
    }

    enum Space: Structure.PersistentValue {
        case normal(Presentation)
        case percent(Presentation, Int)
        case full(Presentation)

        var presentation: Presentation {
            switch self {
            case .normal(let presentation),
                 .full(let presentation):
                presentation
            case .percent(let presentation, _):
                presentation
            }
        }
    }

    enum Layout: Structure.PersistentValue {
        case list
        case canvas
        case mindMap
        case miniMindMiap
        case gallery
    }

    enum Order: Structure.PersistentValue {
        case sorted(Structure.Aspect.ID, ascending: Bool = true)
        case multiSorted([Order])
    }

    enum Sequence: Structure.PersistentValue {
        case ordered(Information.Condition, order: [Order])
        case unordered(Information.Condition)

        var roles: Set<Structure.Role.ID> {
            switch self {
            case .ordered(let condition, _):
                condition.roles
            case .unordered(let condition):
                condition.roles
            }
        }
    }

    case empty
    case undefined
    case label(String)
    case aspect(Structure.Aspect.ID, appearance: Appearance = .normal, editable: Bool = true)
    case horizontal([Space], alignment: Alignment = Alignment.top)
    case vertical([Space], alignment: Alignment = Alignment.leading)
    case sequence([Sequence], layout: Layout)
//    case exclosing(Presentation, header: Presentation? = nil)
    case named(String, Presentation, [Layout], [Appearance])
    case indirect([Structure.Role.ID])
    case present(Structure.Role.ID)
    case reference(Sequence)

//    var roles: [Structure.Role.ID] {
//        switch self {
//        case .horizontal(let spaces, _), .vertical(let spaces, _):
//            return spaces.flatMap { $0.presentation.roles }
//        case .sequence(let sequences, _):
//            return sequences.flatMap { $0.roles }
//        case .exclosing(_, let header):
//            return header.roles
//        case .named(_, let presentation, _):
//            return presentation.roles
//        case .indirect(let roles):
//            return roles
//        case .present(let role):
//            return [role]
//        default:
//            return []
//        }
//    }

    var containsSequence: Bool {
        switch self {
        case .horizontal(let spaces, let alignment), .vertical(let spaces, let alignment):
            return spaces.first { $0.presentation.containsSequence } != nil ? true : false
        case .sequence(_, _):
            return true
        case .reference(_):
            return true
//        case .exclosing(let presentation, let header):
//            return presentation.containsSequence 
        case .named(_, let presentation, _, _):
            return presentation.containsSequence
        default:
            return false
        }
    }

    init(_ name: String, layout: [Layout], appearance: [Appearance], _ presentation: Presentation) {
        self = .named(name, presentation, layout, appearance)
    }

    init(_ aspectId: String, appearance: Appearance = .normal, editable: Bool = true) {
        self = .aspect(UUID(uuidString: aspectId)!, appearance: appearance, editable: editable)
    }

    //        @ViewBuilder
    //        func view(for item: Information.Item, editable: Bool = false) -> some View {
    //            switch self {
    //            case .empty:
    //                EmptyView()
    //            case .undefined:
    //                Image(systemName: "checkerboard.rectangle")
    //            case let .label(label):
    //                Text(label)
    //            case let .horizontal(children, alignment):
    //                HorizontalView(item: item, children: children, alignment: alignment, editable: editable)
    //            case let .vertical(children, alignment):
    //                VerticalView(item: item, children: children, alignment: alignment, editable: editable)
    //            case let .aspect(aspectId, form, isEditable):
    //                AspectView(item: item, aspectId: aspectId, form: form, editable: isEditable && editable)
    //            }
    //        }

//        static func aspect(_ aspect: Structure.Aspect, appearance: Appearance, editable: Bool = true) -> Presentation {
//            .aspect(aspect.id, appearance: appearance, editable: editable)
//        }
//
//        static func aspect(_ aspect: String, form: String, editable: Bool = true) -> Presentation {
//            .aspect(UUID(uuidString: aspect)!, form: form, editable: editable)
//        }

    static func vertical(_ children: Space..., alignment: Alignment = .leading) -> Presentation {
        .vertical(children, alignment: alignment)
    }
}

//    struct AspectView: View {
//        @State var structure: Structure
//        @State var item: Information.Item
//        var aspectId: Structure.Aspect.ID
//        var form: String
//        var editable = false
//
//        var body: some View {
//            if let aspect = structure[Aspect.self , aspectId] {
//                aspect.view(for: item, as: form, editable: editable)
//            } else {
//                EmptyView()
//            }
//        }
//    }
//
//    struct HorizontalView: View {
//        @ObservedObject var item: Information.Item
//        var children: [Presentation]
//        var alignment: Presentation.Alignment
//        var editable: Bool
//
//        var verticalAlignment: VerticalAlignment {
//            switch alignment {
//            case .leading:
//                return .top
//            case .center:
//                return .center
//            case .trailing:
//                return .bottom
//            default:
//                return .center
//            }
//        }
//
//        var body: some View {
//            HStack(alignment: verticalAlignment) {
//                ForEach(0 ..< children.count, id: \.self) { index in
//                    children[index].view(for: item, editable: editable)
//                }
//            }
//        }
//    }
//
//    struct VerticalView: View {
//        @ObservedObject var item: Information.Item
//        var children: [Presentation]
//        var alignment: Presentation.Alignment
//        var editable: Bool
//
//        var horizontalAlignment: HorizontalAlignment {
//            switch alignment {
//            case .leading:
//                return .leading
//            case .center:
//                return .center
//            case .trailing:
//                return .trailing
//            default:
//                return .center
//            }
//        }
//
//        var body: some View {
//            VStack(alignment: horizontalAlignment) {
//                ForEach(0 ..< children.count, id: \.self) { index in
//                    children[index].view(for: item, editable: editable)
//                }
//            }
//        }
//    }
// }

// extension Structure.Role.Representation: Identifiable {
//    var id: Int {
//        switch self {
//        case .aspect:
//            return 1
//        case .horizontal:
//            return 2
//        case .vertical:
//            return 3
//        }
//    }
// }

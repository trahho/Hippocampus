//
//  Arrangement.swift
//  Hippocampus
//
//  Created by Guido Kühn on 19.01.23.
//

import Foundation
import SwiftUI

extension Structure {
    indirect enum Representation: Structure.PersistentValue {
        enum Alignment: Structure.PersistentValue {
            case leading, center, trailing, top, bottom
        }

        case empty
        case undefined
        case horizontal([Representation], alignment: Alignment = Alignment.top)
        case vertical([Representation], alignment: Alignment = Alignment.leading)
        case aspect(Structure.Aspect.ID, form: Structure.Aspect.Presentation.Form, editable: Bool = true)
        case label(String)

        @ViewBuilder
        func view(for item: Information.Item, editable: Bool = false) -> some View {
            switch self {
            case .empty:
                EmptyView()
            case .undefined:
                Image(systemName: "checkerboard.rectangle")
            case let .label(label):
                Text(label)
            case let .horizontal(children, alignment):
                HorizontalView(item: item, children: children, alignment: alignment, editable: editable)
            case let .vertical(children, alignment):
                VerticalView(item: item, children: children, alignment: alignment, editable: editable)
            case let .aspect(aspectId, form, isEditable):
                AspectView(item: item, aspectId: aspectId, form: form, editable: isEditable && editable)
            }
        }

        static func aspect(_ aspect: Structure.Aspect, form: Structure.Aspect.Presentation.Form, editable: Bool = true) -> Representation {
            .aspect(aspect.id, form: form, editable: editable)
        }

        static func aspect(_ aspect: String, form: Structure.Aspect.Presentation.Form, editable: Bool = true) -> Representation {
            .aspect(UUID(uuidString: aspect)!, form: form, editable: editable)
        }

        static func vertical(_ children: Representation..., alignment: Alignment = .leading) -> Representation {
            .vertical(children, alignment: alignment)
        }
    }

    struct AspectView: View {
        @EnvironmentObject var structure: Structure
        @ObservedObject var item: Information.Item
        var aspectId: Structure.Aspect.ID
        var form: Aspect.Presentation.Form
        var editable = false

        var body: some View {
            if let aspect = structure.aspects[aspectId] {
                aspect.view(for: item, as: form, editable: editable)
            } else {
                EmptyView()
            }
        }
    }

    struct HorizontalView: View {
        @ObservedObject var item: Information.Item
        var children: [Representation]
        var alignment: Representation.Alignment
        var editable: Bool

        var verticalAlignment: VerticalAlignment {
            switch alignment {
            case .leading:
                return .top
            case .center:
                return .center
            case .trailing:
                return .bottom
            default:
                return .center
            }
        }

        var body: some View {
            HStack(alignment: verticalAlignment) {
                ForEach(0 ..< children.count, id: \.self) { index in
                    children[index].view(for: item, editable: editable)
                }
            }
        }
    }

    struct VerticalView: View {
        @ObservedObject var item: Information.Item
        var children: [Representation]
        var alignment: Representation.Alignment
        var editable: Bool

        var horizontalAlignment: HorizontalAlignment {
            switch alignment {
            case .leading:
                return .leading
            case .center:
                return .center
            case .trailing:
                return .trailing
            default:
                return .center
            }
        }

        var body: some View {
            VStack(alignment: horizontalAlignment) {
                ForEach(0 ..< children.count, id: \.self) { index in
                    children[index].view(for: item, editable: editable)
                }
            }
        }
    }
}

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

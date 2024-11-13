//
//  Structure.Aspect.swift
//  Hippocampus
//
//  Created by Guido Kühn on 27.12.22.
//

import Foundation
import Grisu
import Smaug
import SwiftUI

extension Structure {
    class Aspect: Structure.Object, EditableListItem, Pickable {
        // MARK: Properties

        @Relation(\Structure.Role.aspects) var role: Structure.Role?
        @Relation(\Structure.Particle.aspects) var particle: Structure.Particle?

        @Property var name: String = ""
        @Property var kind: Kind = .text
        @Property var computation: Information.Computation?
        @Property var modification: Information.Modification?
        @Property var presentation: [Presentation.Appearance] = [.normal, .icon]

        // MARK: Computed Properties

        var description: String {
            name
        }

        var information: Information {
            store as! Information
        }

        var isComputed: Bool {
            computation != nil
        }

        private var getAspect: (Aspect.ID) -> Aspect? { { self[Aspect.self, $0] }}

        // MARK: Functions

//        @Relation(\Role.aspects) var role: Role!

        subscript<T>(_: T.Type, _ item: Aspectable, form: Structure.Aspect.Kind.Form? = nil) -> T? where T: Information.Value {
            get { self[item, form].value as? T }
            set { self[item, form] = Value(newValue) }
        }

        subscript(_ item: Aspectable, form: Structure.Aspect.Kind.Form?) -> Value {
            get {
                if let computation, let structure = store as? Structure {
                    return computation.compute(for: item, structure: structure)
                } else {
                    return getValue(item: item, form: form)
                }
            }
            set {
                if let modification, let structure = store as? Structure {
                    modification.modify(item, structure: structure)
                } else {
                    setValue(item: item, value: newValue, form: form)
                }
            }
        }

        func getValue(item: Aspectable, form: Structure.Aspect.Kind.Form?) -> Value {
            switch kind {
            case .date:
                getDate(item: item, form: form)
            case .drawing:
                getDrawing(item: item, form: form)
            default:
                item[id]
            }
        }

        func setValue(item: Aspectable, value: Value, form: Structure.Aspect.Kind.Form?) {
            switch kind {
            case .date:
                setDate(item: item, value: value, form: form)
            case .drawing:
                setDrawing(item: item, value: value, form: form)
            default:
                item[id] = value
            }
        }

        func getDate(item: Aspectable, form: Structure.Aspect.Kind.Form?) -> Value {
            guard let date = item[id].value as? Date else { return Value() }
            guard let form else { return Value(date) }
            switch form {
            case .date:
                let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
                return Value(components.date)
            case .time:
                let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
                return Value(components.date)
            case .weekday:
                let components = Calendar.current.dateComponents([.weekday], from: date)
                return Value(components.weekday)
            }
        }

        func setDate(item: Aspectable, value: Value, form: Structure.Aspect.Kind.Form?) {
            guard let date = value.value as? Date else {
                return
            }
            guard let form else {
                item[id] = value
                return
            }
            switch form {
            case .date:
                var newComponents = Calendar.current.dateComponents(in: TimeZone.current, from: date)
                if let date = item[id].value as? Date {
                    let components = Calendar.current.dateComponents(in: TimeZone.current, from: date)
                    newComponents.hour = components.hour
                    newComponents.minute = components.minute
                    newComponents.second = components.second
                }
                item[id] = Value(newComponents.date!)
            case .time:
                var newComponents = Calendar.current.dateComponents(in: TimeZone.current, from: date)
                if let date = item[id].value as? Date {
                    let components = Calendar.current.dateComponents(in: TimeZone.current, from: date)
                    newComponents.year = components.year
                    newComponents.month = components.month
                    newComponents.day = components.day
                }
                item[id] = Value(newComponents.date!)
            default:
                return
            }
        }

        func getDrawing(item: Aspectable, form _: Structure.Aspect.Kind.Form?) -> Value {
            guard let key = item[id].value as? UUID else {
                return .nil
            }
            let cache = self[Document.Drawing.self, key.uuidString]
            return Value(cache.content)
        }

        func setDrawing(item: Aspectable, value: Value, form _: Structure.Aspect.Kind.Form?) {
            guard let newValue = value.drawing else { return }
            if let key = item[id].value as? UUID {
                self[Document.Drawing.self, key.uuidString].content = newValue
            } else {
                let key = UUID()
                item[id] = Value(key)
                self[Document.Drawing.self, key.uuidString].content = newValue
            }
        }
    }
}

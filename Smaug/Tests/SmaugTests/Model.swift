//
//  File.swift
//
//
//  Created by Guido Kühn on 05.05.23.
//

import Foundation
import Smaug

class Document: DatabaseDocument {
    @Data var a = AA()
    @Data var b = BB()
}

class AA: DataStore<AA.Storage> {
    @Objects var aa: Set<A>
}

extension AA {
    enum Storage: TimedValueStorage {
        case a(ValueStorage)

        init?(_ value: (any PersistentValue)?) {
            if value == nil { return nil }
            else if let value = ValueStorage(value) { self = .a(value) }
            else { fatalError() }
        }

        var value: (any PersistentValue)? {
            switch self {
            case let .a(value): return value.value
            }
        }
    }
}

class BB: DataStore<BB.Storage> {
    @Objects var bb: Set<B>
}

extension BB {
    enum Storage: TimedValueStorage {
        case a(ValueStorage)

        init?(_ value: (any PersistentValue)?) {
            if value == nil { return nil }
            else if let value = ValueStorage(value) { self = .a(value) }
            else { fatalError() }
        }

        var value: (any PersistentValue)? {
            switch self {
            case let .a(value): return value.value
            }
        }
    }
}

extension AA {
    class A: Object {
        @Property var a: String
        @Object var b: BB.B!
        @Objects var c: Set<BB.B>
    }
}

extension BB {
    class B: Object {
        @Property var b: String
        @Reference(\AA.A.b) var a: AA.A!
        @Reference(\AA.A.c) var c: AA.A!
        @References(\AA.A.c) var cc: Set<AA.A>

    }
}

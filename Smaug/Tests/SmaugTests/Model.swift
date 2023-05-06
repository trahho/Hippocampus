//
//  File.swift
//
//
//  Created by Guido Kühn on 05.05.23.
//

import Foundation
import Smaug

class Document: DatabaseDocument {
    @Data var a = A()
    @Data var b = B()
    @Transient var c = C()
}

class A: DataStore<A.Storage> {
    @Objects var aa: Set<A>
}

class B: DataStore<B.Storage> {
    @Objects var bb: Set<B>
}

class C: ObjectMemory {
    @Objects var cc: Set<C>
}

extension A {
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

extension B {
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

extension A {
    class A: Object {
        @Property var s: String
        @Object var b: B.B!
        @Objects var bb: Set<B.B>
        @Relation(\C.C.a) var c: C.C!
    }
}

extension B {
    class B: Object {
        @Property var s: String
        @Relation(\A.A.b) var a: A.A!
        @Relation(\A.A.bb) var a1: A.A!
        @Relations(\A.A.bb) var aa: Set<A.A>
    }
}

extension C {
    class C: Object {
        @Property var s: String
        @Object var a: A.A!
    }
}


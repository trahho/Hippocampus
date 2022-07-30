//
//  InjectedPropertyWrapper.swift
//  Hippocampus
//
//  Created by Guido Kühn on 06.05.22.
//

import Foundation

@propertyWrapper
struct Injected<T> {
    private let keyPath: WritableKeyPath<Injector, T>
    var wrappedValue: T {
        get { Injector[keyPath] }
        set { Injector[keyPath] = newValue }
    }

    init(_ keyPath: WritableKeyPath<Injector, T>) {
        self.keyPath = keyPath
    }

    init(wrappedValue: T, _ keyPath: WritableKeyPath<Injector, T>) {
        self.keyPath = keyPath
        self.wrappedValue = wrappedValue
    }
}

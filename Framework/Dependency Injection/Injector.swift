////
////  InjectionValuesContainer.swift
////  Hippocampus
////
////  Created by Guido Kühn on 06.05.22.
////
//
//import Foundation
//
//struct Injector {
//    private static var current = Injector()
//
//    static subscript<K>(key: K.Type) -> K.Value where K: InjectionKey {
//        get { key.injectedValue }
//        set { key.injectedValue = newValue }
//    }
//
//    static subscript<T>(_ keyPath: WritableKeyPath<Injector, T>) -> T {
//        get { current[keyPath: keyPath] }
//        set { current[keyPath: keyPath] = newValue }
//    }
//}

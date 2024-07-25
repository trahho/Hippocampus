//
//  Aspectable.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.07.24.
//

protocol Aspectable: AnyObject {
    subscript(_: Structure.Aspect.ID) -> Structure.Aspect.Value? { get set }

    subscript(_: Structure.Aspect) -> Structure.Aspect.Value? { get set }

    subscript<T>(_: Structure.Aspect, _: T.Type) -> T? where T: Information.Value { get set }
}

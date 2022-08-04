//
//  File.swift
//
//
//  Created by Dejan Skledar on 07/09/2020.
//

import Combine
import Foundation

public typealias Serializable = SerializableEncodable & SerializableDecodable & ObservableObject

@propertyWrapper
/// Property wrapper for Serializable (Encodable + Decodable) properties.
/// The Object itself must conform to Serializable (or SerializableEncodable / SerializableDecodable)
/// Default value is by default nil. Can be used directly without arguments
public class Serialized<T>: ObservableObject {
    var key: String?
    var alternateKey: String?
    var cancellable: AnyCancellable?

    @Published private var _value: T?

    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    public var wrappedValue: T {
        get { fatalError() }
        set { fatalError() }
    }

    /// Wrapped value getter for optionals
    private func _wrappedValue<U>(_: U.Type) -> U? where U: ExpressibleByNilLiteral {
        return _value as? U
    }

    /// Wrapped value getter for non-optionals
    private func _wrappedValue<U>(_: U.Type) -> U {
        return _value as! U
    }

//    /// Register Observation
//    private func registerObservation<Observed, Observer>(o) where U: ObservableObject {
//        let observed = _value as! U
//        cancellable = observed.objectWillChange.sink(receiveValue: { _ in
//            if let publisher = instance.objectWillChange as? Combine.ObservableObjectPublisher {
//                publisher.send()
//            }
//        })
//    }

    /// Ignore Observation
    private func registerObservation<U>(_: U.Type, instance: U) {}

    public static subscript<EnclosingSelf: ObservableObject>(
        _enclosingInstance instance: EnclosingSelf,
        wrapped _: ReferenceWritableKeyPath<EnclosingSelf, T>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Serialized>
    ) -> T {
        get {
            let storage = instance[keyPath: storageKeyPath]
            return storage._wrappedValue(T.self)
        }
        set {
            let storage = instance[keyPath: storageKeyPath]
            if let publisher = instance.objectWillChange as? Combine.ObservableObjectPublisher {
                publisher.send()
            }
            storage._value = newValue
//            storage.registerObservation(instance)
        }
    }

    /// Defualt init for Serialized wrapper
    /// - Parameters:
    ///   - key: The JSON decoding key to be used. If `nil` (or not passed), the property name gets used for decoding
    ///   - alternateKey: The alternative JSON decoding key to be used, if the primary decoding key fails
    ///   - value: The default value to be used, if the decoding fails. If not passed, `nil` is used.
    public init(wrappedValue: @autoclosure @escaping () -> T, _ key: String? = nil, alternateKey: String? = nil) {
        self.key = key
        self.alternateKey = alternateKey
        self._value = wrappedValue()
    }

    public init(_ key: String? = nil, alternateKey: String? = nil) {
        self.key = key
        self.alternateKey = alternateKey
        self._value = nil
    }
}

/// Encodable support
extension Serialized: EncodableProperty where T: Encodable {
    /// Basic property encoding with the key (if present), or propertyName if key not present
    /// - Parameters:
    ///   - container: The default container
    ///   - propertyName: The Property Name to be used, if key is not present
    /// - Throws: Throws JSON encoding errorj
    public func encodeValue(from container: inout EncodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)
        try container.encodeIfPresent(_wrappedValue(T.self), forKey: codingKey)
    }
}

/// Decodable support
extension Serialized: DecodableProperty where T: Decodable {
    /// Adding the DecodableProperty support for Serialized annotated objects, where the Object conforms to Decodable
    /// - Parameters:
    ///   - container: The decoding container
    ///   - propertyName: The property name of the Wrapped property. Used if no key (or nil) is present
    /// - Throws: Doesnt throws anything; Sets the wrappedValue to nil instead (possible crash for non-optionals if no default value was set)
    public func decodeValue(from container: DecodeContainer, propertyName: String) throws {
        let codingKey = SerializedCodingKeys(key: key ?? propertyName)

        if let value = try? container.decodeIfPresent(T.self, forKey: codingKey) {
            _value = value
        } else {
            guard let altKey = alternateKey else { return }
            let altCodingKey = SerializedCodingKeys(key: altKey)
            if let value = try? container.decodeIfPresent(T.self, forKey: altCodingKey) {
                _value = value
            }
        }
    }
}

//
//  Inlet.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 26/05/2025.
//

/// Binding wrapper for MaxObject
///
/// Used by Outlet() object
@propertyWrapper
public struct MaxBinding<T>: MaxIOComponent {
    public var wrappedValue: T {
        get { get() }
        set { set(newValue) }
    }

    public let get: () -> T
    public let set: (T) -> Void
    public let observe: (@escaping (T) -> Void) -> Void // Add this

    public func callAsFunction(_ newValue: T) {
        set(newValue)
    }

    public init(get: @escaping () -> T, set: @escaping (T) -> Void, observe: @escaping (@escaping (T) -> Void) -> Void = { _ in }) {
        self.get = get
        self.set = set
        self.observe = observe
    }
}

// MARK: -

/// Local state storage for MaxObject
///
/// Used with MaxBinding by Outlet() object
@propertyWrapper
public class MaxState<T: Equatable>: MaxIOComponent {
    private var value: T
    private var observers: [(T) -> Void] = []

    public var wrappedValue: T {
        get { value }
        set {
            value = newValue
            notifyObservers()
        }
    }

    public var projectedValue: MaxBinding<T> {
        MaxBinding(
            get: { self.value },
            set: { self.wrappedValue = $0 },
            observe: { callback in
                self.observers.append(callback)
                callback(self.value) // optional: emit initial value
            }
        )
    }

    public init(wrappedValue: T) {
        value = wrappedValue
    }

    private func notifyObservers() {
        for obs in observers {
            obs(value)
        }
    }
}

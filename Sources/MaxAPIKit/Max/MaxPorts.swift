//
//  MaxInlets.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//

@propertyWrapper
struct Inlet<T> {
    var wrappedValue: T

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

@propertyWrapper
struct Outlet<T> {
    var wrappedValue: T {
        set(v) { self.binding.wrappedValue = v }
        get { self.binding.wrappedValue }
    }
    let binding: MaxBinding<T>

    init(_ binding: MaxBinding<T>, type: MaxDataType) {
        self.binding = binding
//      self.type = type
    }

    // Function to send data out of the outlet to Max
    func send(_ value: T) {
        // Under the hood, call outlet_* C functions
    }
}

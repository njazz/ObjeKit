//
//  MaxInlets.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 25/05/2025.
//

//@propertyWrapper
//public struct Inlet<T> {
//    public var wrappedValue: T
//
//    public init(wrappedValue: T) {
//        self.wrappedValue = wrappedValue
//    }
//}
//
//@propertyWrapper
//public struct Outlet<T> {
//    public var wrappedValue: T {
//        set(v) { self.binding.wrappedValue = v }
//        get { self.binding.wrappedValue }
//    }
//    let binding: MaxBinding<T>
//
//    public init(_ binding: MaxBinding<T>, type: MaxDataType) {
//        self.binding = binding
////      self.type = type
//    }
//
//    // Function to send data out of the outlet to Max
//    func send(_ value: T) {
//        // Under the hood, call outlet_* C functions
//    }
//}

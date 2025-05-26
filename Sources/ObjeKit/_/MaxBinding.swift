//
//  Binding.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//

//@propertyWrapper
//public class MaxBind<T> {
//  private var value: T
//
//    public init(wrappedValue: T) {
//    self.value = wrappedValue
//  }
//
//    public var wrappedValue: T {
//    get { value }
//    set { value = newValue }
//  }
//
//    public var projectedValue: MaxBinding<T> {
//      MaxBinding(
//      get: { self.value },
//      set: { self.value = $0 }
//    )
//  }
//}
//
//// MARK: -
//
//public struct MaxBinding<Value> {
//  let get: () -> Value
//  let set: (Value) -> Void
//
//  var wrappedValue: Value {
//    get { get() }
//    nonmutating set { set(newValue) }
//  }
//}

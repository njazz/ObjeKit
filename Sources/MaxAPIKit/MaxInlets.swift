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

  // Here you might want hooks for handling incoming messages
  // or connecting to Max’s inlet mechanism
}

@propertyWrapper
struct Outlet<T> {
  var wrappedValue: T

  // Function to send data out of the outlet to Max
  func send(_ value: T) {
    // Under the hood, call outlet_* C functions
  }
}

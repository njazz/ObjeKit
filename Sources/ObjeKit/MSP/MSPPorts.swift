//
//  MSPInlet.swift
//  ObjeKit
//
//  Created by alex on 25/05/2025.
//

@propertyWrapper
struct MSPInlet {
  var wrappedValue: UnsafePointer<Float>?
}

@propertyWrapper
struct MSPOutlet {
  var wrappedValue: UnsafeMutablePointer<Float>?
}

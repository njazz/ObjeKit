//
//  MSPObject.swift
//  ObjeKit
//
//  Created by alex on 25/05/2025.
//


protocol MSPObject : MaxObject {
  func setupDSP(sampleRate: Double, vectorSize: UInt)

  func perform(inputVectors: [UnsafePointer<Float>], outputVectors: [UnsafeMutablePointer<Float>], vectorSize: UInt)
}

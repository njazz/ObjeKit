//
//  MSPObject.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 25/05/2025.
//

import DSPLKit

/// STUB for DSP object
protocol MSPObject : MaxObject {
  func setupDSP(sampleRate: Double, vectorSize: UInt)

  func perform(inputVectors: [UnsafePointer<Float>], outputVectors: [UnsafeMutablePointer<Float>], vectorSize: UInt)
}

//
//  DSPObject.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//

public protocol DSPInspectable {
    var allInputs: [UnsafePointer<Float>] { get }
    var allOutputs: [UnsafeMutablePointer<Float>] { get }
}

public protocol DSPObject : DSPInspectable {
    func process()
    var configuration: DSPConfiguration { get set }
    
    @DSPBuilder static func build() -> some DSPObject
    

}
// MARK: -

public struct DSPConfiguration {
    public var sampleRate: Float
    public var blockSize: Int
}

// MARK: -

extension DSPInspectable {
    public var allInputs: [UnsafePointer<Float>] {
        Mirror(reflecting: self).children.compactMap { child in
            if let input = child.value as? AudioIn {
                return input.wrappedValue
            }
            return nil
        }
    }

    public var allOutputs: [UnsafeMutablePointer<Float>] {
        Mirror(reflecting: self).children.compactMap { child in
            if let output = child.value as? AudioOut {
                return output.wrappedValue
            }
            return nil
        }
    }
}

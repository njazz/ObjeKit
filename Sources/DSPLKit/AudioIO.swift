//
//  AudioIn.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 26/05/2025.
//

/// Basic audio input wrapper
@propertyWrapper
public struct AudioIn: DSPIOComponent {
    public var wrappedValue: UnsafePointer<Float>
    public init(wrappedValue: UnsafePointer<Float>) {
        self.wrappedValue = wrappedValue
    }
    
    public func accept<V>(visitor: V) where V: DSPIOVisitor {
        visitor.visit(self)
    }
}

/// Basic audio output wrapper
@propertyWrapper
public struct AudioOut: DSPIOComponent {
    public var wrappedValue: UnsafeMutablePointer<Float>
    public init(wrappedValue: UnsafeMutablePointer<Float>) {
        self.wrappedValue = wrappedValue
    }
    
    public func accept<V>(visitor: V) where V: DSPIOVisitor {
        visitor.visit(self)
    }
}

//
//  Argument.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//

/// read-only argument
@propertyWrapper
public struct Argument<T>: MaxIOComponent {
    var optional: Bool = true
    
    public var wrappedValue: T
    public init(wrappedValue: T, _ index: UInt8? = nil) {
        self.wrappedValue = wrappedValue
    }
    
    public func accept<V>(visitor: V) where V : MaxClassIOVisitor {
        visitor.visit(self)
    }
}

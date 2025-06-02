//
//  Argument.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//

/// Read-only argument wrapper
@propertyWrapper
public struct Argument<T>: MaxIOComponent {
    var optional: Bool = true
    var description: String? = nil
    
    public var wrappedValue: T
    public init(wrappedValue: T, optional: Bool = true, description : String? = nil) {
        self.wrappedValue = wrappedValue
        self.optional = optional
        self.description = description
    }
    
    public func accept<V>(visitor: V) where V : MaxIOVisitor {
        visitor.visit(self)
    }
}

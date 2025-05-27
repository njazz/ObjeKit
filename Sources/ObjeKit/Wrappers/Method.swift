//
//  MaxMethod.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//

public enum MaxMethodKind {
     case bang
     case int
     case float
     case selector(String)
    case list
 }

// MARK: -

@propertyWrapper
public struct MaxMethod: MaxIOComponent {
    public let kind: MaxMethodKind
    private let _function: Any
    
    // Type-erased function getter
    public var wrappedValue: Any {
        _function
    }
    
    // Store any function matching known signatures
    public init(_ function: @escaping () -> Void) {
        self.kind = .bang
        self._function = function
    }
    
    public init(_ function: @escaping (CDouble) -> Void) {
        self.kind = .float
        self._function = function
    }
    
    public init(_ function: @escaping (CLong) -> Void) {
        self.kind = .int
        self._function = function
    }
    
    public init(_ name: String, _ function: @escaping ([MaxValue]) -> Void) {
        self.kind = .selector(name)
        self._function = function
    }
    
    public init(_ name: String, _ function: @escaping () -> Void) {
        self.kind = .selector(name)
        self._function = { (_:[MaxValue]) in function() }
    }
    
    public init(_ function: @escaping ([MaxValue]) -> Void) {
        self.kind = .list
        self._function = function
    }
    
    public func accept<V: MaxIOVisitor>(visitor: V) {
        visitor.visit(self)
    }
    
    // Optionally, helper to call with dynamic casting
    public func callAsBang() {
        if let fn = _function as? () -> Void {
            fn()
        }
    }
    
    public func callAsFloat(_ v: Double) {
        if let fn = _function as? (Double) -> Void {
            fn(v)
        }
    }
    
    public func callAsInt(_ v: CLong) {
        if let fn = _function as? (CLong) -> Void {
            fn(v)
        }
    }
    
    public func callAsSelector(_ args: [MaxValue]) {
        if let fn = _function as? ([MaxValue]) -> Void {
            fn(args)
        }
    }
}

//
//  MaxMethod.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//

//
//@propertyWrapper
//public struct MaxMethod: MaxIOComponent {
//    var name : String
//    public var wrappedValue: () -> Void
//    public init(_ name: String = "", wrappedValue: @escaping () -> Void) {
//        self.name = name
//        self.wrappedValue = wrappedValue
//    }
//    
//    public func accept<V>(visitor: V) where V : MaxIOVisitor {
//        visitor.visit(self)
//    }
//}


public enum MaxMethodKind {
     case bang
     case int
     case float
     case selector(String)
 }

@propertyWrapper
public struct MaxMethod: MaxIOComponent {
    public let kind: MaxMethodKind
    private let _function: Any
    
    // Type-erased function getter
    public var wrappedValue: Any {
        _function
    }
    
    // Store any function matching known signatures
    public init(_ kind: MaxMethodKind, _ function: @escaping () -> Void) {
        self.kind = kind
        self._function = function
    }
    
    public init(_ kind: MaxMethodKind, _ function: @escaping (Float) -> Void) {
        self.kind = kind
        self._function = function
    }
    
    public init(_ kind: MaxMethodKind, _ function: @escaping (Int) -> Void) {
        self.kind = kind
        self._function = function
    }
    
    public init(_ kind: MaxMethodKind, _ function: @escaping (String, [MaxValue]) -> Void) {
        self.kind = kind
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
    
    public func callAsFloat(_ v: Float) {
        if let fn = _function as? (Float) -> Void {
            fn(v)
        }
    }
    
    public func callAsInt(_ v: Int) {
        if let fn = _function as? (Int) -> Void {
            fn(v)
        }
    }
    
    public func callAsSelector(_ sel: String, _ args: [MaxValue]) {
        if let fn = _function as? (String, [MaxValue]) -> Void {
            fn(sel, args)
        }
    }
}

// @propertyWrapper
// public struct MaxMethod<Signature>: MaxIOComponent {
//     public let kind: MaxMethodKind
//     public var wrappedValue: Signature
//
//     public init(_ kind: MaxMethodKind, wrappedValue: Signature) {
//         self.kind = kind
//         self.wrappedValue = wrappedValue
//     }
//     
//     // Convenience init for () -> Void
//     public init(_ kind: MaxMethodKind, _ function: @escaping () -> Void) where Signature == () -> Void {
//         self.kind = kind
//         self.wrappedValue = function as! Signature
//     }
//
//     // Convenience init for (Float) -> Void
//     public init(_ kind: MaxMethodKind, _ function: @escaping (Float) -> Void) where Signature == (Float) -> Void {
//         self.kind = kind
//         self.wrappedValue = function as! Signature
//     }
//
//     // Convenience init for (Int) -> Void
//     public init(_ kind: MaxMethodKind, _ function: @escaping (Int) -> Void) where Signature == (Int) -> Void {
//         self.kind = kind
//         self.wrappedValue = function as! Signature
//     }
//     
//     // Convenience init for (String, [MaxValue]) -> Void
//     public init(_ kind: MaxMethodKind, _ function: @escaping (String, [MaxValue]) -> Void) where Signature == (String, [MaxValue]) -> Void {
//         self.kind = kind
//         self.wrappedValue = function as! Signature
//     }
//     
//     public func accept<V>(visitor: V) where V: MaxIOVisitor {
//         visitor.visit(self)
//     }
// }
 

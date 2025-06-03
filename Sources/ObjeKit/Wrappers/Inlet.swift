//
//  MaxMethod.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//

public enum PortIndex {
    case index(Int), any, available
}

public enum PortKind {
    case bang
    case int
    case float
    case selector(String)
    case list
}

// MARK: - Inlet / Method combined

/// default inlet 0
public struct Inlet: MaxIOComponent {
    public let kind: PortKind
    public var index: PortIndex

    private let _contents: Any

    // Type-erased function getter
    public var wrappedValue: Any {
        _contents
    }
    
    // MARK: -
    
    public init(_ inlet: PortIndex = .index(0), _ function: @escaping () -> Void) {
        self.index = inlet
        kind = .bang
        _contents = function
    }

    public init(_ inlet: PortIndex = .index(0), _ function: @escaping (CDouble) -> Void) {
        self.index = inlet
        kind = .float
        _contents = function
    }

    public init(_ inlet: PortIndex = .index(0), _ function: @escaping (CLong) -> Void) {
        self.index = inlet
        kind = .int
        _contents = function
    }

    public init(_ inlet: PortIndex = .index(0), _ function: @escaping ([MaxValue]) -> Void) {
        self.index = inlet
        kind = .list
        _contents = function
    }

    public init(_ inlet: PortIndex = .index(0), name: String, _ function: @escaping ([MaxValue]) -> Void) {
        self.index = inlet
        kind = .selector(name)
        _contents = function
    }

    public init(_ inlet: PortIndex = .index(0),  name: String, _ function: @escaping () -> Void) {
        self.index = inlet
        kind = .selector(name)
        _contents = { (_: [MaxValue]) in function() }
    }
    
    // MARK: -

    public func accept<V: MaxIOVisitor>(visitor: V) {
        visitor.visit(self)
    }

    // MARK: -
    
    // Optionally, helper to call with dynamic casting
    public func callAsBang() {
        if let fn = _contents as? () -> Void {
            fn()
        }
    }

    public func callAsFloat(_ v: Double) {
        if let fn = _contents as? (Double) -> Void {
            fn(v)
        }
    }

    public func callAsInt(_ v: CLong) {
        if let fn = _contents as? (CLong) -> Void {
            fn(v)
        }
    }

    public func callAsSelector(_ args: [MaxValue]) {
        if let fn = _contents as? ([MaxValue]) -> Void {
            fn(args)
        }
    }
}

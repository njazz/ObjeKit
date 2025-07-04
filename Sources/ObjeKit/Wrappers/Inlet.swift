//
//  MaxMethod.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 26/05/2025.
//

/// Inlet / Outlet port
///
/// index: may be exact (**.index()**) next **.available** or a wildcard **.any**
public enum PortIndex {
    case index(Int), any, available
}

public enum PortKind: Equatable {
    case bang
    case int
    case float
    case selector(String)
    case list
}

// MARK: - Inlet / Method combined

/// Max Inlet component
///
/// NB default is always inlet 0
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
        index = inlet
        kind = .bang
        _contents = function
    }

    public init(_ inlet: PortIndex = .index(0), _ function: @escaping (CDouble) -> Void) {
        index = inlet
        kind = .float
        _contents = function
    }

    public init(_ inlet: PortIndex = .index(0), _ function: @escaping (CLong) -> Void) {
        index = inlet
        kind = .int
        _contents = function
    }

    public init(_ inlet: PortIndex = .index(0), _ function: @escaping ([MaxValue]) -> Void) {
        index = inlet
        kind = .list
        _contents = function
    }

    public init(_ inlet: PortIndex = .index(0), name: String, _ function: @escaping ([MaxValue]) -> Void) {
        index = inlet
        kind = .selector(name)
        _contents = function
    }

    public init(_ inlet: PortIndex = .index(0), name: String, _ function: @escaping () -> Void) {
        index = inlet
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

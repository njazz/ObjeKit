//
//  MaxIOVisitor.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//

/// Helper class to attach dynamically to instance components: I/O, Methods
public protocol MaxIOVisitor {
    func visit<T>(_ inlet: Inlet<T>)
    func visit<T>(_ outlet: Outlet<T>)
    func visit(_ method: MaxMethod)
    
    func visit<T>(_ argument: Argument<T>) -> Bool
}

/// Helper class to attach dynamically to class components: Arguments, Attributes
public protocol MaxClassIOVisitor {
    func visit<T>(_ attribute: Attribute<T>)
}

// MARK: -

public extension MaxIOVisitor {
    func visit<T>(_ argument: Argument<T>) -> Bool { return true }
}

public extension MaxClassIOVisitor {
    func visit<T>(_ attribute: Attribute<T>) {}
}

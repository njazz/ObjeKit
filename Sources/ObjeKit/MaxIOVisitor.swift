//
//  MaxIOVisitor.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 26/05/2025.
//

/// Helper class to attach dynamically to instance components: I/O, Methods
public protocol MaxIOVisitor {
    func visit(_ outlet: MaxOutput)

    func visit<T>(_ outlet: Outlet<T>)
    func visit(_ method: Inlet)

    func visit<T>(_ argument: Argument<T>) -> Bool
}

/// Helper class to attach dynamically to class components: Attributes
public protocol MaxClassIOVisitor {
    func visit<T>(_ attribute: Attribute<T>)
}

// MARK: - default implementation

public extension MaxIOVisitor {
    func visit(_ outlet: MaxOutput) {}

    func visit<T>(_ argument: Argument<T>) -> Bool { return true }
}

public extension MaxClassIOVisitor {
    func visit<T>(_ attribute: Attribute<T>) {}
}

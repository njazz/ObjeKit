//
//  MaxIOVisitor.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//


public protocol MaxIOVisitor {
    func visit<T>(_ inlet: Inlet<T>)
    func visit<T>(_ outlet: Outlet<T>)
    func visit(_ method: MaxMethod)
}

public protocol MaxClassIOVisitor {
    func visit<T>(_ argument: Argument<T>)
    func visit<T>(_ argument: Attribute<T>)
}

// MARK: -

public extension MaxClassIOVisitor {
    func visit<T>(_ argument: Argument<T>) {}
    func visit<T>(_ argument: Attribute<T>) {}
}

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
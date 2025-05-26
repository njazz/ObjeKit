//
//  MaxObject.swift
//  MaxAPIKit
//
//  Created by alex on 25/05/2025.
//

@_implementationOnly import MaxSDKBridge

public protocol Initializable {
    init()
}

// MARK: -

public protocol MaxIOVisitor {
    func visit<T>(_ inlet: Inlet<T>)
    func visit<T>(_ outlet: Outlet<T>)
    func visit(_ method: MaxMethod)
}

// MARK: -

public protocol MaxObject: AnyObject, Initializable {
    static var className: String { get }

    var objects: MaxObject { get }
    var io: MaxIOComponent { get }
}

public protocol MaxComponent: AnyObject, Initializable {
    var children: [MaxComponent] { get }
}

public protocol MaxIOComponent {
    func accept<V: MaxIOVisitor>(visitor: V)
}

// MARK: -

public extension MaxObject {
    var objects: MaxObject { CompositeMaxObject() }
    var io: MaxIOComponent { CompositeMaxIO() }
}

public extension MaxIOComponent {
    func accept<V: MaxIOVisitor>(visitor: V) {}
}

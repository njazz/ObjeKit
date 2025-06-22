//
//  MaxObject.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 25/05/2025.
//

@_implementationOnly import MSDKBridge

public protocol Initializable {
    init()
}

// MARK: -

public protocol MaxObject: AnyObject, Initializable {
    /// This must be provided by object and is used in object's setup() function
    static var className: String { get }

    /// some special case: if returns true, the class instantiation during object setup will be bypassed (avoiding registering the Attribute classes)
    static var disableClassInstance: Bool { get }

    /// object elements: Inlets, Outlets, Arguments, Attributes
    var io: MaxIOComponent { get }
}

public protocol MaxIOComponent {
    func accept<V: MaxIOVisitor>(visitor: V)
    func accept<V: MaxClassIOVisitor>(visitor: V)
}

// MARK: -

public extension MaxObject {
    var io: MaxIOComponent { CompositeMaxIO() }

    static var disableClassInstance: Bool { false }
}

public extension MaxIOComponent {
    func accept<V: MaxIOVisitor>(visitor: V) {}
    func accept<V: MaxClassIOVisitor>(visitor: V) {}
}

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
    static var className: String { get }

    var objects: MaxObject { get }
    var io: MaxIOComponent { get }
}

public protocol MaxComponent: AnyObject, Initializable {
    var children: [MaxComponent] { get }
}

public protocol MaxIOComponent {
    func accept<V: MaxIOVisitor>(visitor: V)
    func accept<V: MaxClassIOVisitor>(visitor: V)
}

// MARK: -

public extension MaxObject {
    /// NB: not yet used:
    var objects: MaxObject { CompositeMaxObject() }
    
    var io: MaxIOComponent { CompositeMaxIO() }
}

public extension MaxIOComponent {
    func accept<V: MaxIOVisitor>(visitor: V) {}
    func accept<V: MaxClassIOVisitor>(visitor: V) {}
}

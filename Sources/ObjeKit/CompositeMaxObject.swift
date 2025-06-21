//
//  CompositeMaxObject.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 26/05/2025.
//

public class CompositeMaxObject: MaxObject {
    public static var className: String { "Composite" }

    public let objects: [MaxObject]

    public required init() {
        objects = []
    }

    public init(_ children: [MaxObject] = []) {
        objects = children
    }

    public var io: [MaxIOComponent] {
        objects.compactMap { $0.io }
    }
}

// MARK: -

public class CompositeMaxIO : MaxIOComponent {
    public let io: [MaxIOComponent]
    
    public required init() {
        io = []
    }
    
    public init(_ io: [MaxIOComponent] = []) {
        self.io = io
    }
    
    public func accept<V: MaxIOVisitor>(visitor: V) {
        for component in io {
            component.accept(visitor: visitor)
        }
    }
}

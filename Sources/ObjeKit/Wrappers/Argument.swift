//
//  Argument.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//

/// Read-only argument wrapper
public struct Argument<T : MaxValueConvertible>: MaxIOComponent {
    var optional: Bool
    var description: String?
    var setter: (T)->Void
    
    public init(optional: Bool = true, description : String? = nil, setter: @escaping (T)->Void = { (x:T) in }) {
        self.setter = setter
        self.optional = optional
        self.description = description
    }
    
    public func accept<V>(visitor: V) where V : MaxIOVisitor {
        let _ = visitor.visit(self)
    }
}

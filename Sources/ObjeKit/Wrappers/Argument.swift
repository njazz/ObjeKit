//
//  Argument.swift
//  ObjeKit
//
//  Created by Alex Nadzharov on 26/05/2025.
//

/// Read-only Max Argument wrapper
///
/// NB should support only 1 atom & should later include type check
public struct Argument<T : MaxValueConvertible>: MaxIOComponent {
    var optional: Bool
    var description: String?
    var setter: (T)->Void
    
    public init(optional: Bool = true, _ description : String? = nil, setter: @escaping (T)->Void = { (x:T) in }) {
        self.setter = setter
        self.optional = optional
        self.description = description
    }
    
    public func accept<V>(visitor: V) where V : MaxIOVisitor {
        let _ = visitor.visit(self)
    }
}

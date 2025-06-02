//
//  Argument.swift
//  ObjeKit
//
//  Created by alex on 26/05/2025.
//

//public protocol MaxArgumentValue {
//    init()
//}
//
//extension Int: MaxArgumentValue {}
//extension UInt: MaxArgumentValue {}
//extension Double: MaxArgumentValue {}
//extension Float: MaxArgumentValue {}
//extension String: MaxArgumentValue {}

public typealias MaxArgumentValue = LosslessConvertible


 func convertArgumentValue<T: MaxArgumentValue>(_ value: T) -> T{
     return value
 }
 

// MARK: -

/// Read-only argument wrapper
public struct Argument<T : MaxArgumentValue>: MaxIOComponent {
    var optional: Bool
    var description: String?
    var setter: (T)->Void
    
    public init(optional: Bool = true, description : String? = nil, setter: @escaping (T)->Void = { (x:T) in }) {
        self.setter = setter
        self.optional = optional
        self.description = description
    }
    
    public func accept<V>(visitor: V) where V : MaxIOVisitor {
        visitor.visit(self)
    }
}
